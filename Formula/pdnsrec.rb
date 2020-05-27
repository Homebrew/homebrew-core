class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.3.1.tar.bz2"
  sha256 "54230852fcad3c6291651069c383f7ea88c5d29ce3c561decb2f40a063f52fd9"

  bottle do
    sha256 "7070944c3f1ff85a200f6010cd792ae0843f7c54e0e0e351f391876310ccdc7e" => :catalina
    sha256 "2db26f78466c6e0d08b1e2b3a09c124906b2a3a50c60bb2f574b0c346a427d34" => :mojave
    sha256 "b0ed864e0ce19f38919cf0b401ca2b0dc6a33889032278070c4e2cec30388162" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

  # Fix compilation on systems that do not define HOST_NAME_MAX.
  # Remove with the next release.
  patch :p2, :DATA

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end

__END__
diff --git a/pdns/misc.cc b/pdns/misc.cc
index f9248af42a..5cb4dbe812 100644
--- a/pdns/misc.cc
+++ b/pdns/misc.cc
@@ -57,6 +57,7 @@
 #include <sys/types.h>
 #include <pwd.h>
 #include <grp.h>
+#include <limits.h>
 #ifdef __FreeBSD__
 #  include <pthread_np.h>
 #endif
@@ -1563,3 +1564,39 @@ bool setPipeBufferSize(int fd, size_t size)
   return false;
 #endif /* F_SETPIPE_SZ */
 }
+
+static size_t getMaxHostNameSize()
+{
+#if defined(HOST_NAME_MAX)
+  return HOST_NAME_MAX;
+#endif
+
+#if defined(_SC_HOST_NAME_MAX)
+  auto tmp = sysconf(_SC_HOST_NAME_MAX);
+  if (tmp != -1) {
+    return tmp;
+  }
+#endif
+
+  /* _POSIX_HOST_NAME_MAX */
+  return 255;
+}
+
+std::string getCarbonHostName()
+{
+  std::string hostname;
+  hostname.resize(getMaxHostNameSize() + 1, 0);
+
+  if (gethostname(const_cast<char*>(hostname.c_str()), hostname.size()) != 0) {
+    throw std::runtime_error(stringerror());
+  }
+
+  auto pos = hostname.find(".");
+  if (pos != std::string::npos) {
+    hostname.resize(pos);
+  }
+
+  boost::replace_all(hostname, ".", "_");
+
+  return hostname;
+}
diff --git a/pdns/misc.hh b/pdns/misc.hh
index 4bd9439a87..795e8ec855 100644
--- a/pdns/misc.hh
+++ b/pdns/misc.hh
@@ -607,3 +607,5 @@ bool isSettingThreadCPUAffinitySupported();
 int mapThreadToCPUList(pthread_t tid, const std::set<int>& cpus);
 
 std::vector<ComboAddress> getResolvers(const std::string& resolvConfPath);
+
+std::string getCarbonHostName();
diff --git a/pdns/rec-carbon.cc b/pdns/rec-carbon.cc
index 4e0cedb00f..458a25d5ca 100644
--- a/pdns/rec-carbon.cc
+++ b/pdns/rec-carbon.cc
@@ -32,17 +32,13 @@ try
   if(namespace_name.empty()) {
     namespace_name="pdns";
   }
-  if(hostname.empty()) {
-    char tmp[HOST_NAME_MAX+1];
-    memset(tmp, 0, sizeof(tmp));
-    if (gethostname(tmp, sizeof(tmp)) != 0) {
-      throw std::runtime_error("The 'carbon-ourname' setting has not been set and we are unable to determine the system's hostname: " + stringerror());
+  if (hostname.empty()) {
+    try {
+      hostname = getCarbonHostName();
+    }
+    catch(const std::exception& e) {
+      throw std::runtime_error(std::string("The 'carbon-ourname' setting has not been set and we are unable to determine the system's hostname: ") + e.what());
     }
-    char *p = strchr(tmp, '.');
-    if(p) *p=0;
-
-    hostname=tmp;
-    boost::replace_all(hostname, ".", "_");    
   }
   if(instance_name.empty()) {
     instance_name="recursor";
