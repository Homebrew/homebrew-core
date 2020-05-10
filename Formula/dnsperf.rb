class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.3.tar.gz"
  sha256 "de5270401c1b553deb965a90c1cf071ba64eda7cdbc58d07026c7e20e9529163"

  bottle do
    cellar :any
    sha256 "7c89a8d743a3a62653aebf2d0a6102991a88efa5fb0b8743d425745b2cc60e2a" => :catalina
    sha256 "8901054afed6de33bdbbe8eda68f9238f0ac3915acd5ee319c942acae741841a" => :mojave
    sha256 "f67934e4c9b06aafd7220815911a6fa27e430ef0add19b5fe8cfda3adb9dcae9" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "bind"
  depends_on "libxml2"

  # BIND 9.16 compatibility patch
  # suggested in here, https://github.com/DNS-OARC/dnsperf/issues/67#issue-570581974
  patch :DATA

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end

__END__
diff --git a/src/dns.c b/src/dns.c
index e94101b..1b52e76 100644
--- a/src/dns.c
+++ b/src/dns.c
@@ -137,10 +137,7 @@ perf_dns_createctx(bool updates)
         return NULL;

     mctx   = NULL;
-    result = isc_mem_create(0, 0, &mctx);
-    if (result != ISC_R_SUCCESS)
-        perf_log_fatal("creating memory context: %s",
-            isc_result_totext(result));
+    isc_mem_create(&mctx);

     ctx = isc_mem_get(mctx, sizeof(*ctx));
     if (ctx == NULL) {
@@ -373,9 +370,7 @@ perf_dns_parseednsoption(const char* arg, isc_mem_t* mctx)

     option->mctx   = mctx;
     option->buffer = NULL;
-    result         = isc_buffer_allocate(mctx, &option->buffer, strlen(value) / 2 + 4);
-    if (result != ISC_R_SUCCESS)
-        perf_log_fatal("out of memory");
+    isc_buffer_allocate(mctx, &option->buffer, strlen(value) / 2 + 4);

     result = isc_parse_uint16(&code, copy, 0);
     if (result != ISC_R_SUCCESS) {
diff --git a/src/dnsperf.c b/src/dnsperf.c
index 2d3cb1f..ee27f5d 100644
--- a/src/dnsperf.c
+++ b/src/dnsperf.c
@@ -389,10 +389,7 @@ setup(int argc, char** argv, config_t* config)
     isc_result_t result;
     const char*  mode = 0;

-    result = isc_mem_create(0, 0, &mctx);
-    if (result != ISC_R_SUCCESS)
-        perf_log_fatal("creating memory context: %s",
-            isc_result_totext(result));
+    isc_mem_create(&mctx);

     dns_result_register();

diff --git a/src/resperf.c b/src/resperf.c
index b4c24b5..ffbac24 100644
--- a/src/resperf.c
+++ b/src/resperf.c
@@ -228,10 +228,7 @@ setup(int argc, char** argv)
     isc_result_t result;
     const char*  _mode = 0;

-    result = isc_mem_create(0, 0, &mctx);
-    if (result != ISC_R_SUCCESS)
-        perf_log_fatal("creating memory context: %s",
-            isc_result_totext(result));
+    isc_mem_create(&mctx);

     dns_result_register();
