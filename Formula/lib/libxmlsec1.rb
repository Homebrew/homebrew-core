class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.7.tar.gz"
  sha256 "d82e93b69b8aa205a616b62917a269322bf63a3eaafb3775014e61752b2013ea"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd0bd557a369d063dd16612dde3a3a673aea225376db8ee674cdb97867bff28c"
    sha256 cellar: :any,                 arm64_sonoma:  "e1b1f314c2c9d2aa76755bfa33a8f4018455cb697110e8718d5044e3452b0183"
    sha256 cellar: :any,                 arm64_ventura: "d4b92a70262c9ba01a7ec1956bee5c677de07ccae16b86f1f9e4d5cadb94b0f2"
    sha256 cellar: :any,                 sonoma:        "ab66efc3b6fb18b9f00d8fbacebba05c6299a0af4ffd6bbfd0bc2c1ac0617b19"
    sha256 cellar: :any,                 ventura:       "8a5ac37287e46fb1b50a11b99a802b095feb1664bf86e92fae1757a809f985ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251a6cf05aa3f3dcf207029f3ce9b17a93f02d201701dba8c9724696f4e5eb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091ee1ac09d65ac2cfab2f1695366534a65e6c8f304782136de299001b6291a5"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@3"
  uses_from_macos "libxslt"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = [
      "--disable-crypto-dl",
      "--disable-apps-crypto-dl",
      "--with-nss=no",
      "--with-nspr=no",
      "--enable-mscrypto=no",
      "--enable-mscng=no",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"xmlsec1", "--version"
    system bin/"xmlsec1-config", "--version"
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
