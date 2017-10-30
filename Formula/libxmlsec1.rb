class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.25.tar.gz"
  sha256 "967ca83edf25ccb5b48a3c4a09ad3405a63365576503bf34290a42de1b92fcd2"

  bottle do
    cellar :any
    sha256 "9698c648420c3a443e7eb3721eac9467b5c41d27e08bf3c2c383c8b3310f5cd6" => :high_sierra
    sha256 "443057ec59c7f9be61c3983a6660b8423fc0c90ac2210085d1d97b364a33c593" => :sierra
    sha256 "c59fe51ea068c7c3d4ffa14775192067080f37f78682348776330ba610b07621" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2" if MacOS.version <= :lion
  # Yes, it wants both ssl/tls variations.
  depends_on "openssl" => :recommended
  depends_on "gnutls" => :recommended
  depends_on "libgcrypt" if build.with? "gnutls"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl"]

    args << "--with-openssl=#{Formula["openssl"].opt_prefix}" if build.with? "openssl"
    args << "--with-libxml=#{Formula["libxml2"].opt_prefix}" if build.with? "libxml2"

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/dl.c b/src/dl.c
index 6e8a56a..0e7f06b 100644
--- a/src/dl.c
+++ b/src/dl.c
@@ -141,6 +141,7 @@ xmlSecCryptoDLLibraryCreate(const xmlChar* name) {
     }

 #ifdef XMLSEC_DL_LIBLTDL
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
