class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  # TODO: Uncomment below when patch is no longer needed.
  # url "https://downloads.isc.org/isc/bind9/9.20.7/bind-9.20.7.tar.xz"
  # sha256 "43323c8d22d2144282c37b4060ec11e98c24835e225688876fad08ba7b95dca6"
  license "MPL-2.0"
  revision 1
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.7/bind-9.20.7.tar.xz"
    sha256 "43323c8d22d2144282c37b4060ec11e98c24835e225688876fad08ba7b95dca6"

    patch :DATA
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "475a19780d6d715095643e643e29234fc4a8957fdf5fe0771804b90ca2dd5c73"
    sha256 arm64_sonoma:  "3543326f334022fe41d3ad73c307245b300ac1a1cfe95af00a58035923b4b3f3"
    sha256 arm64_ventura: "cb80d80f5611f36f33133d685ec183a48157243a81ff5b753f5c95316605e9b2"
    sha256 sonoma:        "58d1065019d4c9fa3aa6f1cdaa8dc9d0de38a584849319dc765dd2bb057db0f5"
    sha256 ventura:       "9a4908c982aba2d52f16de4110a1d88fe00cc122694b655dfa02de3983b1d99d"
    sha256 arm64_linux:   "0e003c29242ddc0b9fdb7180cb6266fb09ce4af72aac1aca0429a560e4c9d1f4"
    sha256 x86_64_linux:  "eeab5b333e38bf01971fc4597bb4580cd131a78780d77e835a3f92f75abf2859"
  end

  depends_on "pkgconf" => :build

  depends_on "jemalloc"
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "userspace-rcu"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libcap"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--localstatedir=#{var}",
      "--with-json-c",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
      "--without-lmdb",
    ]
    system "./configure", *args

    system "make"
    system "make", "install"

    (buildpath/"named.conf").write named_conf
    system "#{sbin}/rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"
  end

  def post_install
    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
    require_root true
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end

__END__
diff --git i/lib/isc/xml.c w/lib/isc/xml.c
index 7dd9424..ed8ee94 100644
--- i/lib/isc/xml.c
+++ w/lib/isc/xml.c
@@ -19,6 +19,7 @@
 #include <libxml/parser.h>
 #include <libxml/xmlversion.h>
 
+#ifndef __APPLE__
 static isc_mem_t *isc__xml_mctx = NULL;
 
 static void *
@@ -44,17 +45,20 @@ isc__xml_free(void *ptr) {
 	isc_mem_free(isc__xml_mctx, ptr);
 }
 
+#endif /* !__APPLE__ */
 #endif /* HAVE_LIBXML2 */
 
 void
 isc__xml_initialize(void) {
 #ifdef HAVE_LIBXML2
+#ifndef __APPLE__
 	isc_mem_create(&isc__xml_mctx);
 	isc_mem_setname(isc__xml_mctx, "libxml2");
 	isc_mem_setdestroycheck(isc__xml_mctx, false);
 
 	RUNTIME_CHECK(xmlMemSetup(isc__xml_free, isc__xml_malloc,
 				  isc__xml_realloc, isc__xml_strdup) == 0);
+#endif /* !__APPLE__ */
 
 	xmlInitParser();
 #endif /* HAVE_LIBXML2 */
@@ -69,10 +73,8 @@ isc__xml_shutdown(void) {
 }
 
 void
-isc__xml_setdestroycheck(bool check) {
-#if HAVE_LIBXML2
+isc__xml_setdestroycheck(bool check ISC_ATTTR_UNUSED) {
+#if defined(HAVE_LIBXML2) && !defined(__APPLE__)
 	isc_mem_setdestroycheck(isc__xml_mctx, check);
-#else
-	UNUSED(check);
-#endif
+#endif /* HAVE_LIBXML2 && !__APPLE__ */
 }
