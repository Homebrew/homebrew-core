class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.4.tar.gz"
  sha256 "45ad9078d41ae76844ad2f8651600ffeec0fdd128ead988a8d69e907c57aee75"
  license "MIT"

  livecheck do
    url "https://www.aleksey.com/xmlsec/download/"
    regex(/href=.*?xmlsec1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "408d3fee98965fed2bb5c3534b9205e4a44197fd2590d539c54abec98e855767"
    sha256 cellar: :any,                 arm64_ventura:  "687072490c390f0ca5726066b25ac45c819863ab2fbd8fb00ade24046cf30895"
    sha256 cellar: :any,                 arm64_monterey: "99ec155d703937ab71ff84133e42d6fe1e3a52bd11a4eaa43b000ce52dcc21b4"
    sha256 cellar: :any,                 sonoma:         "e8266e14e7cc534ee8995fc369dfc8e365c561c09f39ec9d6f5ca7c51db036ea"
    sha256 cellar: :any,                 ventura:        "cd3c045a06728102ad8dd83a5db5a0a15270717424857265be64144b38e039e0"
    sha256 cellar: :any,                 monterey:       "f5418fcbf1f7b47ba604c3327b9b23b424f3122071fcfc338c129caef897b5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79c1415b0a2687e45e14991a2760208e72b92de97632f35d9166193710eea10"
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
