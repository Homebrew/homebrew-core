class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.6.tar.gz"
  sha256 "952b626ad3f3be1a4598622dab52fdab2a8604d0837c1b00589f3637535af92f"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fa6ba58cc9412b98a27930230dc48d6640895dc49d72a869e10d0e337bbcaf0"
    sha256 cellar: :any,                 arm64_sonoma:  "9082d72d07de372b53b6d6c8545fb7fb01aaf0d102512ab7bc46aacd6b5f42dd"
    sha256 cellar: :any,                 arm64_ventura: "cebe4fac67b13bc1c1c2d48116229eb794c78b571fe3036142272a0edc01fcb3"
    sha256 cellar: :any,                 sonoma:        "5e606f8c356f9174438d4d965444bf38b6e2c0e97b9f452c6b71c9c0cdb5a3ba"
    sha256 cellar: :any,                 ventura:       "504df3d9c26ffd9c04e6da49fb9d7bd64e44ba1f69e42b4c3cacbd371fec0998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbdf3e9c1bc660992306f640fa0b64bafe4db84ab1fdd0f785256d34e640aa18"
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
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
