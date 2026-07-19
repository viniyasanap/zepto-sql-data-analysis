drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weighInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name is NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--diffrent prouduct categoriers 
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--data cleaning

--products with price = 0;
SELECT * FROM zepto
WHERE mrp = 0 OR discountSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rs
UPDATE zepto
SET mrp = mrp/100.0,
discountSellingPrice = discountSellingPrice/100.0; 

SELECT mrp, discountSellingPrice FROM zepto


--Q1. FIND THE TOP 10 BEST-VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY
SELECT category,
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.FIND ALL THE PRODUCTS WHERE MRP IS GREATER THAT 500RS AND DISCOUNT IS LESS THAN 100.
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
WHERE mrp > 500 And discountPercent < 100
ORDER BY mrp DESC, discountPercent DESC;

--Q5.IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE.
SELECT category,
ROUND(AVG(DiscountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100G AND SORT BY BEAT VALUES
SELECT DISTINCT name, weighInGms, discountSellingPrice,
ROUND(discountSellingPrice/weighInGms,2) AS price_per_gram
FROM zepto
WHERE weighInGms >= 100
ORDER BY price_per_gram;

--Q7.GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, MEDIUM, BULK.
SELECT DISTINCT name, weighInGms,
CASE WHEN weighInGms < 1000 THEN 'Low'
     WHEN weighInGms <5000 THEN 'Medium'
     ELSE 'Bulk'
END AS weigh_category
FROM zepto;

--Q8.WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY
SELECT category,
SUM(weighInGms * availableQuantity) AS total_weigh
FROM zepto
GROUP BY category
ORDER BY total_weigh;