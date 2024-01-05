class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.3.tar.gz"
  sha256 "ab5b9a9ffd6960f46f7466d9d91f174ec37e8c31989237ba6b9eacdd816464f2"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f55904ed40085b1f70559f4b77bdab8a6f2ed34e4e089423f382834bee58cf12"
    sha256 cellar: :any,                 arm64_ventura:  "cf2cd4b830192272b767c7d2e417ca07f97d1678ac4753ee3e32cd535f8eeac7"
    sha256 cellar: :any,                 arm64_monterey: "c65068dd3d8322c114538e1450dc8fdf7b51efe09126aabedc7191b7b81215ac"
    sha256 cellar: :any,                 sonoma:         "61978c07417332345a59915df8950084e362b121c0fd92b11986d92985778c78"
    sha256 cellar: :any,                 ventura:        "c3df350196ad05f4130ac7fa3bc6887a8f9dac0d86bbf5efeb933ada1d5f90ee"
    sha256 cellar: :any,                 monterey:       "0b698cbcb50260e51397047d751b4937b2f9c695975a7e8013cf1ec364fb74d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ec703677c04282bb0551fc97b43f6ee05ae168295481548f962c22f1db743a"
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
