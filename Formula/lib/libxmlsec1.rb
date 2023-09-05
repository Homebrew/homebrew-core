class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.1.tar.gz"
  sha256 "10f48384d4fd1afc05fea545b74fbf7c152582f0a895c189f164d55270400c63"
  license "MIT"
  revision 1

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84885abab4b76878e7d54faa368f1739e67f1851f76fdeb95f58a90ccdeefe10"
    sha256 cellar: :any,                 arm64_monterey: "594f5d42459172e49c90d37cc78e52981288aa10c400c3cdafd870ff36a7fcd2"
    sha256 cellar: :any,                 arm64_big_sur:  "8a585dcd1bb0ea9c552eb2e62ac3149f099979eabf9e3d63678d5615d9910875"
    sha256 cellar: :any,                 ventura:        "a8cfbb4816047952db369fb4048c145aa71776c57b23d557dec835600cd38852"
    sha256 cellar: :any,                 monterey:       "f09549465cb0d1471a0f754a3fa80bf0482c471eebe6f4791e2213833395abf4"
    sha256 cellar: :any,                 big_sur:        "1cb5ce8f22460be220613f0bc543197fe395e261e2e34f1f0ef2cb8c98467f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea32b3ff9330f1230c0366c2e266149180d69afbbddf6fb20372e8dbd7694b14"
  end

  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@3"
  uses_from_macos "libxslt"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl",
            "--with-nss=no",
            "--with-nspr=no",
            "--enable-mscrypto=no",
            "--enable-mscng=no",
            "--with-openssl=#{Formula["openssl@3"].opt_prefix}"]

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
