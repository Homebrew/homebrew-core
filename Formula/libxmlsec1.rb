class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.27.tar.gz"
  sha256 "97d756bad8e92588e6997d2227797eaa900d05e34a426829b149f65d87118eb6"

  bottle do
    sha256 "e424d792f7aef55c782280a3ec0424e741dacec4cd06cae87d7d3cfdc9593201" => :mojave
    sha256 "dbdc3bb085b68e2c59924dba4193bdacbf305d8b91bada24a45b4ed1462febba" => :high_sierra
    sha256 "79f41292bc1d6e890b8840119ffc3be5170690d17faa20e9bca18100e66aecfa" => :sierra
    sha256 "698f1c0e00b8e4d1d98894e0d383f8e7cf9644b03e092213100a76f6e0d5e443" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl",
            "--with-openssl=#{Formula["openssl"].opt_prefix}"]

    args << "--with-libxml=#{Formula["libxml2"].opt_prefix}" if build.with? "libxml2"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xmlsec1", "--version"
    system "#{bin}/xmlsec1-config", "--version"
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
