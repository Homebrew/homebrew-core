class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.8.tar.gz"
  mirror "https://github.com/lsh123/xmlsec/releases/download/1.3.8/xmlsec1-1.3.8.tar.gz"
  sha256 "d0180916ae71be28415a6fa919a0684433ec9ec3ba1cc0866910b02e5e13f5bd"
  license "MIT"
  revision 1

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url "https://github.com/lsh123/xmlsec"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc7d7f2bdede18efca4297314a9ce6ed38cc9e0d1bbd5646d8cfa3e99847b1ed"
    sha256 cellar: :any,                 arm64_sequoia: "c815906d815893e06f8e3e2c4b99a46d4bbd12f01d62191a0bbef2ca9cf3568b"
    sha256 cellar: :any,                 arm64_sonoma:  "d7440efc573def202b718f37cc69338e747b8914bed4638214771791460b294c"
    sha256 cellar: :any,                 sonoma:        "4b63d45886511b343d73532455211bbf49455afa4c0dae05d528ae07f3c19122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfeb5578368bd4658c125d80191f9beac3f8c490c037b4467b924d9189cbe099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b86a2aecd40e0bf2758a9e714aac9278195796425644a5e08e508a263c472a"
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
+    lt_dlsetsearchpath("@@HOMEBREW_PREFIX@@/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
