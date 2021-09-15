class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.32.tar.gz"
  sha256 "e383702853236004e5b08e424b8afe9b53fe9f31aaa7a5382f39d9533eb7c043"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1471e1d159d1da7189d24955c1857446e44dfcb16a076f0317191c1b2370daf2"
    sha256 cellar: :any,                 big_sur:       "5aed153ff3381f68d125b08d102bd37e089d117d0c0fb68abde374b7282fa29e"
    sha256 cellar: :any,                 catalina:      "f98ab26235b1d1ea25ad8ca472eb4dce6f81642129c14b95c545fe26f66f666a"
    sha256 cellar: :any,                 mojave:        "56239f6e8cd3205ae408d35b85d1446cdb346310e8c1c662e79bcd3a47c5e4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61cf0321a530d6aa3f8aa8417b4b18b2a2ac13e82a6f130c60f0c3c6b6c65bfc"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@1.1"

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
