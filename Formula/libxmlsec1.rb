class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.34.tar.gz"
  sha256 "52ced4943f35bd7d0818a38298c1528ca4ac8a54440fd71134a07d2d1370a262"
  license "MIT"
  revision 1

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "024bc7d0c29d6538082c6c028cbd05333a114020c43068c51587ac8c826bbbac"
    sha256 cellar: :any,                 arm64_big_sur:  "1f7fe144276fccca532e1cf53d25f02186c994ae49fae45400b5a8e6654abe1c"
    sha256 cellar: :any,                 monterey:       "bc772fda0f897167a0203c54dcc7a1c212a4b31562bd07dec9597383582b729b"
    sha256 cellar: :any,                 big_sur:        "a808516e71f10edefe72faa80fce47215cffb2117d6370808c05576f84cdfd1b"
    sha256 cellar: :any,                 catalina:       "7f2a722846ebdff6e443d769ba2793f05a001c47b0bbaf2d4f527270444cd21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa29289e159f700e07f38d7af68b7bf5832393c65716a2c0303f63e6f86738f3"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
