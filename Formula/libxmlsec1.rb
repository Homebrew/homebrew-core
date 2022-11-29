class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.37.tar.gz"
  sha256 "5f8dfbcb6d1e56bddd0b5ec2e00a3d0ca5342a9f57c24dffde5c796b2be2871c"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63b193778e143a590e38bf5d0665546ddf9f68ae559c277eb39297e95e883a70"
    sha256 cellar: :any,                 arm64_monterey: "6e294979deacd8639d5db88929a44e5fa12bbd8ef9a8cc70700cd208069ae9ff"
    sha256 cellar: :any,                 arm64_big_sur:  "38de14a91a8774b77040555118862c31d9bc6bb5d95ec01db712f5cf62e9790d"
    sha256 cellar: :any,                 ventura:        "4f1322517b41788f7dfc8a393acab0a2b23348fd1debc6c3a12d1c86c028ce57"
    sha256 cellar: :any,                 monterey:       "3faa0f71a28a896ff125bf4303b259d37adfdf40308a851fcf6070f2f9d4aae0"
    sha256 cellar: :any,                 big_sur:        "95ef65e4b964b39794c38c61f5958a736a44f249c6b0505482f39a73ebc70acf"
    sha256 cellar: :any,                 catalina:       "85b660fba93c05052e266970ed5ef9877f1ac405dbab9f06ba954c8d887b95b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c35ccab6f2ccc4bed3c488150d8e5f59ee08af109443ddbf6ed71b97403a77af"
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
