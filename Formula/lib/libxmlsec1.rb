class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.12/xmlsec1-1.3.12.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.12.tar.gz"
  sha256 "24045199af12d93fe5fdbbbf7e386e823e4842071e9432e2b90ac108b889a923"
  license "MIT"
  compatibility_version 4

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9905f22e9a402d3f7c53a68af94fa2a8ed3b1fe208ac42f5090816ebab96065c"
    sha256 cellar: :any, arm64_sequoia: "1ae88a9a8dc9186f5c9913cea9008ce41077a5724438f91907df7e19d4603761"
    sha256 cellar: :any, arm64_sonoma:  "84b6624424df9ad086bfb16a004e5c184500dcdbfecea3c9ea331eecdf474783"
    sha256 cellar: :any, sonoma:        "95612867fe1c0268610d223178ed84a611d601d3d05d4f9f7f7a206677c0da32"
    sha256 cellar: :any, arm64_linux:   "db3dea165faaaf73250c59732b689e4f872a32015e38fbd97d2f8aaebb70d71f"
    sha256 cellar: :any, x86_64_linux:  "183450e158f6cf276b42b8260cc078420c61460c37ac54d3449f4802c1e7be94"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libxml2"
  depends_on "openssl@3"
  uses_from_macos "libxslt"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = %W[
      --disable-apps-crypto-dl
      --disable-crypto-dl
      --disable-mscrypto
      --disable-mscng
      --without-nss
      --without-nspr
      --with-openssl=#{formula_opt_prefix("openssl@3")}
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
+    lt_dlsetsearchpath("@@HOMEBREW_PREFIX@@/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
