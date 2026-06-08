class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.11/xmlsec1-1.3.11.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.11.tar.gz"
  sha256 "53675e98fa83b48201d24f7bfbcaeaa1b51496b8b19ff969785856bdeb196af3"
  license "MIT"
  compatibility_version 3

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bac1c67f0bd350168eff667a8d681b580f77a76e2d5b4099d5dd2c1bec1c6547"
    sha256 cellar: :any,                 arm64_sequoia: "a46e425da9b5abbf83145ac8b7e223654c2b91fae79c39f42bfd2a7170d700b0"
    sha256 cellar: :any,                 arm64_sonoma:  "8991271947badefa216c58643d4f713b598a66133063d2b8204325a36ee8444e"
    sha256 cellar: :any,                 sonoma:        "19f6197df4950d73a4995bdab59a6a961eaa1b50b7a9dd2ab5f5206797bb1d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d10507c035a546e9de6e052d407271b4b797696328b235ea905778e7bde3e97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48adaa263f332b70297e3aa627aec2be891b30331d84d534961e9d15d477ba33"
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
