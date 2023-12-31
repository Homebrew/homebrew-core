class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0-only"
  revision 4

  stable do
    url "https://github.com/ntop/ntopng/archive/refs/tags/5.2.1.tar.gz"
    sha256 "67404ccd87202864d2c3c44426e60cb59cc2e87d746c704b27e6a63d61ec7644"

    depends_on "ndpi"
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "22aa615bc3607d08835f5e21bd7c07ad130975df8222c0dab4d557025035285f"
    sha256 arm64_ventura:  "2114c42413822e68116991e5eed93a11a620dade59ede7aabf9ca7c3c7e94c8b"
    sha256 arm64_monterey: "b8bc6f21ca6eb18aec9eb65e3ada8099720735116122dc5ab5f8936e0c948ba1"
    sha256 sonoma:         "bc284a78ea29d1c59494a2410be22be19b5a5fc2f08955806a0c73f05ee220b4"
    sha256 ventura:        "2c8492211356d9d5186ea91d2598464deab097f42927fc4e117f68124c4adba8"
    sha256 monterey:       "f900ac4856717b8393cfa7cb0101f1c7c519d0f3f757a6654dcfaf55307816a9"
    sha256 x86_64_linux:   "ea5b0422b3e22d713cee0560ec401c048b52ec6a5538e10fc62515c5a322395b"
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "lua" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "redis"
  depends_on "rrdtool"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  fails_with gcc: "5"

  # Allow dynamic linking with nDPI
  # upstream patch references for nDPI 4.4 API changes
  # https://github.com/ntop/ntopng/commit/4397fae2e3e4116b63ffad0f311d827cc310f464
  # https://github.com/ntop/ntopng/commit/c4119304cd47748ae1ed17c1458ebaf915fe5566
  patch :DATA

  def install
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    end

    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    redis_port = free_port
    redis_bin = Formula["redis"].bin
    fork do
      exec redis_bin/"redis-server", "--port", redis_port.to_s
    end
    sleep 3

    mkdir testpath/"ntopng"
    fork do
      exec bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{redis_port}"
    end
    sleep 15

    assert_match "list", shell_output("#{redis_bin}/redis-cli -p #{redis_port} TYPE ntopng.trace")
  end
end

__END__
diff --git a/configure.ac.in b/configure.ac.in
index b32ae1a2d19..9c2ef3eb140 100644
--- a/configure.ac.in
+++ b/configure.ac.in
@@ -234,10 +234,8 @@ if test -d /usr/local/include/ndpi ; then :
 fi

 PKG_CHECK_MODULES([NDPI], [libndpi >= 2.0], [
-   NDPI_INC=`echo $NDPI_CFLAGS | sed -e "s/[ ]*$//"`
-   # Use static libndpi library as building against the dynamic library fails
-   NDPI_LIB="-Wl,-Bstatic $NDPI_LIBS -Wl,-Bdynamic"
-   #NDPI_LIB="$NDPI_LIBS"
+   NDPI_INC="$NDPI_CFLAGS"
+   NDPI_LIB="$NDPI_LIBS"
    NDPI_LIB_DEP=
    ], [
       AC_MSG_CHECKING(for nDPI source)
diff --git a/include/NetworkInterface.h b/include/NetworkInterface.h
index b00abe3..93b36bf 100644
--- a/include/NetworkInterface.h
+++ b/include/NetworkInterface.h
@@ -1047,8 +1047,8 @@ class NetworkInterface : public NetworkInterfaceAlertableEntity {
   inline ndpi_protocol_category_t get_ndpi_proto_category(ndpi_protocol proto) { return(ndpi_get_proto_category(get_ndpi_struct(), proto)); };
   ndpi_protocol_category_t get_ndpi_proto_category(u_int protoid);
   void setnDPIProtocolCategory(u_int16_t protoId, ndpi_protocol_category_t protoCategory);  
-  void nDPILoadIPCategory(char *what, ndpi_protocol_category_t id);
-  void nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id);
+  void nDPILoadIPCategory(char *what, ndpi_protocol_category_t id, char *list_name);
+  void nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id, char *list_name);
   int nDPILoadMaliciousJA3Signatures(const char *file_path);
 
   inline void setLastInterfacenDPIReload(time_t now)      { last_ndpi_reload = now;   }
diff --git a/include/Ntop.h b/include/Ntop.h
index 2f2ce14..de0fd55 100644
--- a/include/Ntop.h
+++ b/include/Ntop.h
@@ -64,6 +64,7 @@ class Ntop {
   u_int num_cpus; /**< Number of physical CPU cores. */
   Redis *redis; /**< Pointer to the Redis server. */
   Mutex m, users_m;
+  std::map<std::string, bool>cachedCustomLists;
 #ifndef HAVE_NEDGE
   ElasticSearch *elastic_search; /**< Pointer of Elastic Search. */
   ZMQPublisher *zmqPublisher;
@@ -145,6 +146,7 @@ class Ntop {
   void checkReloadHostChecks();
   void checkReloadAlertExclusions();
   void checkReloadHostPools();
+  char* getPersistentCustomListName(char *name);
   
  public:
   /**
@@ -596,8 +598,8 @@ class Ntop {
   ndpi_protocol_category_t get_ndpi_proto_category(ndpi_protocol proto);
   ndpi_protocol_category_t get_ndpi_proto_category(u_int protoid);
   void setnDPIProtocolCategory(u_int16_t protoId, ndpi_protocol_category_t protoCategory);  
-  void nDPILoadIPCategory(char *what, ndpi_protocol_category_t id);
-  void nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id);
+  void nDPILoadIPCategory(char *what, ndpi_protocol_category_t id, char *list_name);
+  void nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id, char *list_name);
   int nDPILoadMaliciousJA3Signatures(const char *file_path);
   void setLastInterfacenDPIReload(time_t now);
   bool needsnDPICleanup();
diff --git a/scripts/lua/flow_details.lua b/scripts/lua/flow_details.lua
index 113e722..a7b185c 100644
--- a/scripts/lua/flow_details.lua
+++ b/scripts/lua/flow_details.lua
@@ -472,8 +472,11 @@ else
       print(getApplicationLabel(flow["proto.ndpi"]).."</A> ")
       print("(<A HREF=\""..ntop.getHttpPrefix().."/lua/")
       print("flows_stats.lua?category=" .. flow["proto.ndpi_cat"] .. "\">")
-      print(getCategoryLabel(flow["proto.ndpi_cat"]))
-      print("</A>) ".. formatBreed(flow["proto.ndpi_breed"], flow["proto.is_encrypted"]))
+      print(getCategoryLabel(flow["proto.ndpi_cat"]).."</A>")
+      if(flow["proto.ndpi_cat_file"]) then
+        print(" @ " ..flow["proto.ndpi_cat_file"])
+      end
+      print(") ".. formatBreed(flow["proto.ndpi_breed"], flow["proto.is_encrypted"]))
       print(" ["..i18n("ndpi_confidence")..": "..flow.confidence.."]")
    end
    
diff --git a/scripts/lua/modules/lists_utils.lua b/scripts/lua/modules/lists_utils.lua
index 7799580..999c0ef 100644
--- a/scripts/lua/modules/lists_utils.lua
+++ b/scripts/lua/modules/lists_utils.lua
@@ -497,7 +497,7 @@ local function loadListItem(host, category, user_custom_categories, list, num_li
 	   if((host == "0.0.0.0") or (host == "0.0.0.0/0") or (host == "255.255.255.255")) then
 	     loadWarning(string.format("Bad IPv4 address '%s' in list '%s'", host, list.name))
 	   else
-	     ntop.loadCustomCategoryIp(host, category)
+	     ntop.loadCustomCategoryIp(host, category, list.name)
 	     return "ip"
 	   end
 	 else
@@ -509,7 +509,7 @@ local function loadListItem(host, category, user_custom_categories, list, num_li
       else
 	 -- Domain
 	 if((not list) or (list.format ~= "ip")) then
-	    ntop.loadCustomCategoryHost(host, category)
+	    ntop.loadCustomCategoryHost(host, category, list.name)
 	    return "domain"
 	 else
 	   loadWarning(string.format("Invalid domain '%s' in list '%s'", host, list.name))
diff --git a/scripts/lua/modules/measurements/speedtest.lua b/scripts/lua/modules/measurements/speedtest.lua
index 3675e16..aae5299 100644
--- a/scripts/lua/modules/measurements/speedtest.lua
+++ b/scripts/lua/modules/measurements/speedtest.lua
@@ -10,7 +10,7 @@ local os_utils = require("os_utils")
 local json = require("dkjson")
 local ts_utils = require("ts_utils_core")
 
-local do_trace = false
+local do_trace = true
 local collected_results = {}
 
 -- #################################################################
@@ -134,7 +134,7 @@ return {
 	 -- The function responsible for collecting the results
 	 collect_results = collect_speedtest,
 	 -- The granularities allowed for the probe. See supported_granularities in am_utils.lua
-	 granularities = { "hour" },
+	 granularities = { "min" },
 	 -- The localization string for the measurement unit (e.g. "ms", "Mbits")
 	 i18n_unit = "field_units.mbits",
 	 -- The localization string for the Jitter unit (e.g. "ms", "Mbits")
diff --git a/scripts/lua/modules/timeseries/ts_utils_core.lua b/scripts/lua/modules/timeseries/ts_utils_core.lua
index e1ec9e8..f565e78 100644
--- a/scripts/lua/modules/timeseries/ts_utils_core.lua
+++ b/scripts/lua/modules/timeseries/ts_utils_core.lua
@@ -879,7 +879,7 @@ function ts_utils.getPossiblyChangedSchemas()
       "am_host:val_5mins",
       "am_host:http_stats_hour",
       "am_host:https_stats_hour",
-      "am_host:val_hour",
+      "am_host:val_hour"
    }
 end
 
diff --git a/src/Flow.cpp b/src/Flow.cpp
index c07fe0f..d8a56f6 100644
--- a/src/Flow.cpp
+++ b/src/Flow.cpp
@@ -25,7 +25,7 @@
 
 const ndpi_protocol Flow::ndpiUnknownProtocol = { NDPI_PROTOCOL_UNKNOWN,
 						  NDPI_PROTOCOL_UNKNOWN,
-						  NDPI_PROTOCOL_CATEGORY_UNSPECIFIED };
+						  NDPI_PROTOCOL_CATEGORY_UNSPECIFIED, NULL };
 // #define DEBUG_DISCOVERY
 // #define DEBUG_UA
 // #define DEBUG_SCORE
@@ -5145,6 +5145,9 @@ void Flow::lua_get_min_info(lua_State *vm) {
   lua_push_str_table_entry(vm, "proto.ndpi", get_detected_protocol_name(buf, sizeof(buf)));
   lua_push_str_table_entry(vm, "proto.ndpi_app", ndpi_get_proto_name(iface->get_ndpi_struct(), ndpiDetectedProtocol.app_protocol));
   lua_push_str_table_entry(vm, "proto.ndpi_cat", get_protocol_category_name());
+
+  if(ndpiDetectedProtocol.custom_category_userdata)
+    lua_push_str_table_entry(vm, "proto.ndpi_cat_file", (char*)ndpiDetectedProtocol.custom_category_userdata);
   lua_push_uint64_table_entry(vm, "proto.ndpi_cat_id", get_protocol_category());
   lua_push_str_table_entry(vm, "proto.ndpi_breed", get_protocol_breed_name());
   lua_push_bool_table_entry(vm, "proto.is_encrypted", isEncryptedProto());
diff --git a/src/LuaEngineNtop.cpp b/src/LuaEngineNtop.cpp
index bd2de79..989e80a 100644
--- a/src/LuaEngineNtop.cpp
+++ b/src/LuaEngineNtop.cpp
@@ -578,7 +578,7 @@ static int ntop_initnDPIReload(lua_State* vm) {
 /* ****************************************** */
 
 static int ntop_loadCustomCategoryIp(lua_State* vm) {
-  char *net;
+  char *net, *listname;
   ndpi_protocol_category_t catid;
 
   ntop->getTrace()->traceEvent(TRACE_DEBUG, "%s() called", __FUNCTION__);
@@ -587,7 +587,12 @@ static int ntop_loadCustomCategoryIp(lua_State* vm) {
   net = (char*)lua_tostring(vm, 1);
   if(ntop_lua_check(vm, __FUNCTION__, 2, LUA_TNUMBER) != CONST_LUA_OK) return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_ERROR));
   catid = (ndpi_protocol_category_t)lua_tointeger(vm, 2);
-  ntop->nDPILoadIPCategory(net, catid);
+  ntop->nDPILoadIPCategory(net, catid, listname);
+
+  if(ntop_lua_check(vm, __FUNCTION__, 3, LUA_TSTRING) != CONST_LUA_OK) return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_ERROR));
+  listname = (char*)lua_tostring(vm, 3);
+
+  ntop->nDPILoadIPCategory(net, catid, listname);
 
   lua_pushnil(vm);
   return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_OK));
@@ -596,7 +601,7 @@ static int ntop_loadCustomCategoryIp(lua_State* vm) {
 /* ****************************************** */
 
 static int ntop_loadCustomCategoryHost(lua_State* vm) {
-  char *host;
+  char *host, *listname;
   ndpi_protocol_category_t catid;
 
   ntop->getTrace()->traceEvent(TRACE_DEBUG, "%s() called", __FUNCTION__);
@@ -605,7 +610,11 @@ static int ntop_loadCustomCategoryHost(lua_State* vm) {
   host = (char*)lua_tostring(vm, 1);
   if(ntop_lua_check(vm, __FUNCTION__, 2, LUA_TNUMBER) != CONST_LUA_OK) return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_ERROR));
   catid = (ndpi_protocol_category_t)lua_tointeger(vm, 2);
-  ntop->nDPILoadHostnameCategory(host, catid);
+
+  if(ntop_lua_check(vm, __FUNCTION__, 3, LUA_TSTRING) != CONST_LUA_OK) return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_ERROR));
+  listname = (char*)lua_tostring(vm, 3);
+
+  ntop->nDPILoadHostnameCategory(host, catid, listname);
 
   lua_pushnil(vm);
   return(ntop_lua_return_value(vm, __FUNCTION__, CONST_LUA_OK));
diff --git a/src/NetworkInterface.cpp b/src/NetworkInterface.cpp
index 15a710f..77c514b 100644
--- a/src/NetworkInterface.cpp
+++ b/src/NetworkInterface.cpp
@@ -390,7 +390,7 @@ struct ndpi_detection_module_struct* NetworkInterface::initnDPIStruct() {
     ndpi_load_protocols_file(ndpi_s, ntop->getCustomnDPIProtos());
 
   memset(d_port, 0, sizeof(d_port));
-  ndpi_set_proto_defaults(ndpi_s, 0, NDPI_PROTOCOL_UNRATED, NTOPNG_NDPI_OS_PROTO_ID,
+  ndpi_set_proto_defaults(ndpi_s, 0, 0, NDPI_PROTOCOL_UNRATED, NTOPNG_NDPI_OS_PROTO_ID,
 			  (char*)"Operating System",
 			  NDPI_PROTOCOL_CATEGORY_SYSTEM_OS, d_port, d_port);
 
@@ -498,16 +498,16 @@ void NetworkInterface::loadProtocolsAssociations(struct ndpi_detection_module_st
 
 /* *************************************** */
 
-void NetworkInterface::nDPILoadIPCategory(char *what, ndpi_protocol_category_t id) {
+void NetworkInterface::nDPILoadIPCategory(char *what, ndpi_protocol_category_t id, char *list_name) {
   // ntop->getTrace()->traceEvent(TRACE_NORMAL, "%s(%p) [%s]", __FUNCTION__, ndpi_struct_shadow, what);
 
   if(what && ndpi_struct_shadow)
-    ndpi_load_ip_category(ndpi_struct_shadow, what, id);
+    ndpi_load_ip_category(ndpi_struct_shadow, what, id, (void*)list_name);
 }
 
 /* *************************************** */
 
-void NetworkInterface::nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id) {
+void NetworkInterface::nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id, char *list_name /* NOT used */) {
   // ntop->getTrace()->traceEvent(TRACE_NORMAL, "%s(%p) [%s]", __FUNCTION__, ndpi_struct_shadow, what);
 
   if(what && ndpi_struct_shadow)
diff --git a/src/Ntop.cpp b/src/Ntop.cpp
index c386bdc..cfdf7dc 100644
--- a/src/Ntop.cpp
+++ b/src/Ntop.cpp
@@ -3104,16 +3104,24 @@ void Ntop::finalizenDPIReload() {
 
 /* ******************************************* */
 
-void Ntop::nDPILoadIPCategory(char *what, ndpi_protocol_category_t id) {
-  for(u_int i = 0; i<get_num_interfaces(); i++)
-    if(getInterface(i))  getInterface(i)->nDPILoadIPCategory(what, id);
+void Ntop::nDPILoadIPCategory(char *what, ndpi_protocol_category_t id, char *list_name) {
+  char *persistent_name = getPersistentCustomListName(list_name);
+
+  for(u_int i = 0; i<get_num_interfaces(); i++) {
+    if(getInterface(i))
+      getInterface(i)->nDPILoadIPCategory(what, id, persistent_name);
+  }
 }
 
 /* ******************************************* */
 
-void Ntop::nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id) {
-  for(u_int i = 0; i<get_num_interfaces(); i++)
-    if(getInterface(i))  getInterface(i)->nDPILoadHostnameCategory(what, id);
+void Ntop::nDPILoadHostnameCategory(char *what, ndpi_protocol_category_t id, char *list_name) {
+  char *persistent_name = getPersistentCustomListName(list_name);
+
+  for(u_int i = 0; i<get_num_interfaces(); i++) {
+    if(getInterface(i))
+      getInterface(i)->nDPILoadHostnameCategory(what, id, persistent_name);
+  }
 }
 
 /* ******************************************* */
@@ -3430,4 +3438,23 @@ void Ntop::collectContinuousResponses(lua_State* vm) {
   cping->collectResponses(vm, true /* IPv6 */);
 }
 
+/* ******************************************* */
+
+/*
+  This method is needed to have a string that is not deallocated
+  after a call, but that is persistent inside nDPI
+*/
+char* Ntop::getPersistentCustomListName(char *list_name) {
+  std::string key(list_name);
+  std::map<std::string, bool>::iterator it = cachedCustomLists.find(key);
+
+  if(it == cachedCustomLists.end()) {
+    /* Not found */
+    cachedCustomLists[key] = true;
+    it = cachedCustomLists.find(key);
+  }
+
+  return((char*)it->first.c_str());
+}
+
 #endif
