class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.34.tar.gz"
  sha256 "52ced4943f35bd7d0818a38298c1528ca4ac8a54440fd71134a07d2d1370a262"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1428382252effcdabf34b7ab4bbaf039c353b11219a59127b3fdb4befc974c19"
    sha256 cellar: :any,                 arm64_big_sur:  "40219e9a964a7e5ec08664524ed040bd05b58161ffd1c7bb5207d23d9b54206f"
    sha256 cellar: :any,                 monterey:       "4cd56a217a6e2c596d8a86c239e2d934076a1cc1721dedeb870a7cb73e234388"
    sha256 cellar: :any,                 big_sur:        "f661be8d4f407df484b50ca2b4882bf6ed5a0d0fc526a18bd1dfff0381aaa4ec"
    sha256 cellar: :any,                 catalina:       "d8ab97537391a33597061ddd17f829a3c24b681a875b5e4db16f1c9bd87ed0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75c2f4c33b87c39a0fc77b20fece4eed1679a3cfdfcfba386b07855f92094156"
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
