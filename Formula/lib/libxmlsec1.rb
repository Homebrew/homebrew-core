class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.8.tar.gz"
  mirror "https://github.com/lsh123/xmlsec/releases/download/1.3.8/xmlsec1-1.3.8.tar.gz"
  sha256 "d0180916ae71be28415a6fa919a0684433ec9ec3ba1cc0866910b02e5e13f5bd"
  license "MIT"
  revision 1

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url "https://github.com/lsh123/xmlsec"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c48cfa8328041e1862476ec913a4bafa79fbc201f374483fdf2acd8b852cb77"
    sha256 cellar: :any,                 arm64_sequoia: "19db0998f5f1a02813871d26801f7539edc3590e1b5e40ebbb9a4e90c3075486"
    sha256 cellar: :any,                 arm64_sonoma:  "523eeb5a5a75353805ba933e81c8d559b7ef1daf963f04e94ee18a58c01a193a"
    sha256 cellar: :any,                 sonoma:        "d88edf3d5ccbe612a2ef128a1bba206ede0e212f6d5a08cb800c5226fc97750e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea9d560a48fb126589874b0ecee3b0a210ecb06ea0ef67574e8046a1af0ef307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60dc6a1a1254f6d42250214518232e46199c75223bb5b59e83c31e5db84c7997"
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
+    lt_dlsetsearchpath("@@HOMEBREW_PREFIX@@/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
