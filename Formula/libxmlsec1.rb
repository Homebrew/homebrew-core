class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.1.tar.gz"
  sha256 "10f48384d4fd1afc05fea545b74fbf7c152582f0a895c189f164d55270400c63"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9af6a43ca5ff567b4b7f0dce7bdb8612d3dac9de8d77c3d33b480b7d32684c61"
    sha256 cellar: :any,                 arm64_monterey: "823fd3c54e2eb29ae5462c7b60bba93f9825b5a2d35f39ca50a4828a69902325"
    sha256 cellar: :any,                 arm64_big_sur:  "6290e5004f0d9b28cd60c840f1d023b2d142e55fa158e9cd9c716cdd93f3737e"
    sha256 cellar: :any,                 ventura:        "3f6a404f4531bdb59a570fcde1a4131ac9a846db0c263610d43c7ab12ac73f78"
    sha256 cellar: :any,                 monterey:       "73782af36219a7d463d868b78c7981e5a1ab4a0dc69892f2c037b7772a7b43ae"
    sha256 cellar: :any,                 big_sur:        "449f2276cb3d4a582cfb9f330903e7d7fa166a7cd17907cbbc5571cdde236ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf53ccd427848e24ebf6b2df7d57e9efcc9d3f2f715de9e9926c3bb728405b3"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@1.1"
  uses_from_macos "libxslt"

  on_macos do
    depends_on xcode: :build
  end

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
            "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"]

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
