class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.25.tar.gz"
  sha256 "967ca83edf25ccb5b48a3c4a09ad3405a63365576503bf34290a42de1b92fcd2"

  bottle do
    cellar :any
    sha256 "1240ae0b3a03511cd2740eb49d56ce6ea080a5cbf2fd62201dc6a19fcda173ee" => :high_sierra
    sha256 "98e3453026441a3884271088f581bef19a770fa6401720a4366a4e38335f2745" => :sierra
    sha256 "e16e54d26f7ce2a7ae5fd7025cb421bba71252a9e9c47df251593fdb3d8400a6" => :el_capitan
    sha256 "49cb24946eac37fc2e0f39f55376463b52ae0b702cdd06877ba3bb4e95476f15" => :yosemite
    sha256 "ab08e6b9d0e6a781704d51a876518b340cec25b2593beb7c126a9ffa38768db3" => :mavericks
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
