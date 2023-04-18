class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.0.tar.gz"
  sha256 "df3ad2548288411fc3d44c20879e4c4e90684a1a4fb76a06ae444f957171c9a6"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "899b14359bba10cb924d80d8d21fa68ccf5c54dd2a87a8bf64a6e030c2136bd1"
    sha256 cellar: :any,                 arm64_monterey: "48914d710bcdf4c5b2223a8a1350b40c149739ab1d736dabdbf351b3ab5f3011"
    sha256 cellar: :any,                 arm64_big_sur:  "3f0791efbb7487f113d04704829ffc678a6211b8b42f59e2f5631154432b905c"
    sha256 cellar: :any,                 ventura:        "5ff39681bcdfb5fbd866fcef08032fa5c01be8627a503caccdb2b7de26f66c17"
    sha256 cellar: :any,                 monterey:       "ce5f5e74aee8fe4e23a3bf446335640fd98b84227fb3ec8ffbd9beb5d609025d"
    sha256 cellar: :any,                 big_sur:        "5dda6666a22cf4bed103d0bd100d73cd061d7fe67348c64d665e22bccd34683b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d139084e4b1f193910e144da1bf8d40ec3c2c815faed705b0b96d76efee6b5a4"
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
