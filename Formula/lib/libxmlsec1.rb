class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.3.tar.gz"
  sha256 "ab5b9a9ffd6960f46f7466d9d91f174ec37e8c31989237ba6b9eacdd816464f2"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07b5d4245f094834f734f7b565f7c9b251701a658946a97c4009cd3413f0fbbf"
    sha256 cellar: :any,                 arm64_ventura:  "1be9b04b4fdcf57f3c12db2b29ba60f7f751c342765f0a596e6e5cf676e56cbc"
    sha256 cellar: :any,                 arm64_monterey: "fac1d12419e5109fb3af30b63b2e6ea07bdbbbbfdad2c76651c1fd9b61cf00fb"
    sha256 cellar: :any,                 sonoma:         "688115c81e7669f0bfcb6de834048fc7b440340ba0044e4fea202f2bbf5d190c"
    sha256 cellar: :any,                 ventura:        "2fa460acb52cd77add84da5c218d32a1a439388140672d0740d86cd84aa1015d"
    sha256 cellar: :any,                 monterey:       "a473c6df33bf0230f7d1bd6b51e7c3d802d0b31b3dcb6cfa7442af146d6916a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e624fb9421f05cae655fb1243729e042c92a9a2c8e640c4385c74303248dceaa"
  end

  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on "openssl@3"
  uses_from_macos "libxslt"

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
            "--with-openssl=#{Formula["openssl@3"].opt_prefix}"]

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
