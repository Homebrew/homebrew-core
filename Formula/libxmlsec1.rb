class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.27.tar.gz"
  sha256 "97d756bad8e92588e6997d2227797eaa900d05e34a426829b149f65d87118eb6"

  bottle do
    cellar :any
    sha256 "a39a51783697765844661aded4f26ba2a0b023f4b92ac943c88bd0c67c0d84d1" => :mojave
    sha256 "45c34967fd10f163a23cea398b1902bfda48d7b9095da27e9f34bd319c2ad94e" => :high_sierra
    sha256 "5f40fa6dd23646f140e4472e1e12a364757c446e9453db7bcddd8618abd45b05" => :sierra
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
