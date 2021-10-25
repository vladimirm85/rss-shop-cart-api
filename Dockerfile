# Base dependencies
FROM node:14-alpine AS deps

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force

# Build
FROM deps AS build

COPY * ./
RUN npm run build

# Deploy
FROM node:14-alpine

WORKDIR /app

COPY --from=deps /app/package*.json ./
RUN npm install --only=production && npm cache clean --force

COPY --from=build /app/dist ./dist

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
