class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.10/xmlsec1-1.3.10.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.10.tar.gz"
  sha256 "5915590780566dae4b5d13d51a42fc0e34b30b26fda6f2c5f744ec31b363ee1a"
  license "MIT"
  compatibility_version 2

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51f825cb1ff495c3d8cd39537ca620d080a7788baa5666a64e98f34cba2c3c3e"
    sha256 cellar: :any,                 arm64_sequoia: "18665575c61336c4cd851d105748e8aec6d21830f34cf62503e66368a6ceaa63"
    sha256 cellar: :any,                 arm64_sonoma:  "c0883ca61525c9a82e3055b0a285557636f6e669f37bf5be0c0465399ead7795"
    sha256 cellar: :any,                 sonoma:        "8238f04b0ac3ec78153b98780b175f19e8e56f4727b92918d33e91615a06699a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e71121ba7a168102d78e0f0720354395bdb1ba33c5665b3e83c7b05e7b73790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386f07f2a718de944530b492a65f1db9e5b832fad084f7505a5f673f2875bb18"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libxml2"
  depends_on "openssl@3"
  uses_from_macos "libxslt"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = %W[
      --disable-apps-crypto-dl
      --disable-crypto-dl
      --disable-mscrypto
      --disable-mscng
      --without-nss
      --without-nspr
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
+    lt_dlsetsearchpath("@@HOMEBREW_PREFIX@@/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
