class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.5.tar.gz"
  sha256 "2ffd4ad1f860ec93e47a680310ab2bc94968bd07566e71976bd96133d9504917"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8c05a4a3c421f3249e23fa62ca7351e1e9907a6c35521db8296d1ec93de11401"
    sha256 cellar: :any,                 arm64_sonoma:   "7731d32c5c2ee494f03870631d070debfa83466f08d72f6d4891144ca0f2fd1b"
    sha256 cellar: :any,                 arm64_ventura:  "e632fcf2cff2e0b5d3a08cc8ffbb47b339aaa9c57ea517e8a8d99f0ff4450a30"
    sha256 cellar: :any,                 arm64_monterey: "d6a3ea2f521670b52000d551dc86a1fb0433a16ea976b072d396ecb8cff07e13"
    sha256 cellar: :any,                 sonoma:         "7cac617ce6a3c41ccc883373d25aa5ecea6316a19650fd675d5b7ae4071b0156"
    sha256 cellar: :any,                 ventura:        "b65856e9c1f414238c8c7a58d34afc242dc186e931767cf62bd9f962b9990047"
    sha256 cellar: :any,                 monterey:       "c58bbc73a0c7410edcbb43ad52e1b11913711b5e8ffe5968976d4db562b43824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9328a9d91fd609b96f885d27605f56763bf89ff7d4e5da52d4560e93d6c4d780"
  end

  depends_on "pkg-config" => :build
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
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
