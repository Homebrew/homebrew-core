class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-410.tar.gz"
  sha256 "28c1b28b320acff3fe46c79748c55370ba4333544e0c27e90a3520d42a9914cf"
  license "MIT"
  revision 1

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a911756ebac227c58abeea0a91807874b0d7d38a4a11973e3e17aaa2bfdd60a6"
    sha256 arm64_sonoma:  "ff6373292d7123dccd009ef75f727aae03da1add04cd060368e7cddee61a1bce"
    sha256 arm64_ventura: "a5e25b9c61d4dcb1c93d341dd7a8193ee7ca1311bd4a36a85573ebf28d64eef8"
    sha256 sonoma:        "914efeba3a89993dd1b56e829828eda02769a6c81f456c96819b6dbbd6f70bba"
    sha256 ventura:       "424f04d45c5ef09c4a2e36be8a79a4fa612054a12143f890c1dd09feaf062dba"
    sha256 x86_64_linux:  "e77a1a7ef596fc317dcbd37cd759afb271f1e3269d70e1af64dc7dc0125591d6"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
