class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.33.tar.gz"
  sha256 "26041d35a20a245ed5a2fb9ee075f10825664d274220cb5190340fa87a4d0931"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dec6fd5829e865122d129980ef2ed3744ca8bbf5bb8e20aeccbb7ca39a0ba6d5"
    sha256 cellar: :any,                 arm64_big_sur:  "5f7287fd477e8c9db54ca60d3ba0baccbaaa8f1223c69b468c7c3f5cea51901c"
    sha256 cellar: :any,                 monterey:       "f95fc9af05605a1746f83322b2772e6623a560184814971473f124da8c21e3fe"
    sha256 cellar: :any,                 big_sur:        "fe86e0105c779a17c87ff23e9d676097f01bd6c29c0e8034e523bfa502c7f02f"
    sha256 cellar: :any,                 catalina:       "12f5f73d58175419bf06ff8d0b93da1f47638a279659609e2e2afe29f1061d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9db3f53634ffdbcc8234968e3bce2c42a32f731625506777ac1831f43735df"
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
