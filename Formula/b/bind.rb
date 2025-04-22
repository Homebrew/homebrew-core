class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  # TODO: Uncomment below when patch is no longer needed.
  # url "https://downloads.isc.org/isc/bind9/9.20.8/bind-9.20.8.tar.xz"
  # sha256 "3004d99c476beab49a986c2d49f902e2cd7766c9ab18b261e8b353cabf3a04b5"
  license "MPL-2.0"
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://downloads.isc.org/isc/bind9/9.20.8/bind-9.20.8.tar.xz"
    sha256 "3004d99c476beab49a986c2d49f902e2cd7766c9ab18b261e8b353cabf3a04b5"

    patch :DATA
  end

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d3f84ac0a1a2a1e7f3face1b1c1ec3d529d33b5e4477216a8d7bfe7d21dea66e"
    sha256 arm64_sonoma:  "02169088713697145cf3f3a04a250bb2f2e90a88da201aa7b3d9131cc618309a"
    sha256 arm64_ventura: "622abc3a20a9e7760d745d5b39737aba57c835434c6acb56e521c68f63857016"
    sha256 sonoma:        "5726d8c7f91d12494ee9cd4ee6595fca956586afc6cb6902fbb27b15b5ab8c89"
    sha256 ventura:       "675797d13ab4fb8c98d06aa88876307fa83242d03f61c815e811a8c6436dcadd"
    sha256 arm64_linux:   "10be3b0abd42b95f82cf5f428bfdbd66068dadff4dd8bf8150a589261fd2e9c0"
    sha256 x86_64_linux:  "dc15ca3128f17a61609b0464bae2f092204c0483116c19a3f6de3bd22d256aff"
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
