class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.9/xmlsec1-1.3.9.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.9.tar.gz"
  sha256 "a631c8cd7a6b86e6adb9f5b935d45a9cf9768b3cb090d461e8eb9d043cf9b62f"
  license "MIT"

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a0347f04db0fafdd4c94056e921f5a28a934c718f254bc878dd93e91ce59fb3"
    sha256 cellar: :any,                 arm64_sequoia: "bf8736ca35b30186ac8023ffdd6141104bda810502bf81da0a79a0e9b5e6ea05"
    sha256 cellar: :any,                 arm64_sonoma:  "a46d51ed400865642998a65d2a3f3ea29a514a51e4a89e05028bcd2a605ec644"
    sha256 cellar: :any,                 sonoma:        "c2a986b51f0d901b71400760b77711f34fcfcd3c3f991c5bda92389bdaad1c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116bd2f4c3f372406ae26b53f8e7dc6e6b286abbbd277cfdfb95c8a3db8cad4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94dcf7bb5692df44d334784fb03d2a032e52f71d50b951f1615b330fcccbbaf"
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
