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
    sha256 arm64_sequoia: "e80ed22d86c4a5fef6c89e8bbfab65269a71032a6a52b6bb103a9685013d9ede"
    sha256 arm64_sonoma:  "38364bf644834e6a254362c1b5e417ccb0830fc480dcfec917fe595b6bab7ff4"
    sha256 arm64_ventura: "4c1dbe0b4db181ef597737f90bdee2ee232d5fecef83a1c2a0824d72ae0e60e0"
    sha256 sonoma:        "ff24146494d636c33df4eb670bc0e28937234bb198653041fefa946daffe3a5d"
    sha256 ventura:       "1f06f5ec73358e4b89c7b287fad3dfd816a3aea1d913a91c3b8e6bd46205555f"
    sha256 arm64_linux:   "99756495e4d5931d4d5decbee54f21d256bec8129013fa1e5ce7cdb70db385ed"
    sha256 x86_64_linux:  "9095b82ecd97dc33b68c941b38f5c18b55d598b4b9becb265ebab304d952263e"
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
index 7dd9424..af08a50 100644
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
@@ -64,13 +68,15 @@ void
 isc__xml_shutdown(void) {
 #ifdef HAVE_LIBXML2
 	xmlCleanupParser();
+#ifndef __APPLE__
 	isc_mem_destroy(&isc__xml_mctx);
+#endif /* !__APPLE__ */
 #endif /* HAVE_LIBXML2 */
 }
 
 void
 isc__xml_setdestroycheck(bool check) {
-#if HAVE_LIBXML2
+#if defined(HAVE_LIBXML2) && !defined(__APPLE__)
 	isc_mem_setdestroycheck(isc__xml_mctx, check);
 #else
 	UNUSED(check);
