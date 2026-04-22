class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-420.tar.gz"
  sha256 "9fa739cf28d5f554d982acecb94857b9fe0d0fd839d238dfca90f143c9fab216"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "96b6f94cbac97ca8cc30bcd74c8a258f3462e233d36a0719212f0b9306d2a7ed"
    sha256 arm64_sequoia: "32984610d0f720d52e8ae7877c6188b42c7f28bea9cb6a85bcd28361e3671598"
    sha256 arm64_sonoma:  "1e827e43ee4113c58864be40d072ad77634da3ddd23efd105f8f88065db7b342"
    sha256 sonoma:        "d9624ad29a3278961d986127e7ea31f5c922245ffe94ac3bd8d830889d40a5d7"
    sha256 arm64_linux:   "c889fe50b5079a029381e2a9f988979319dae868b83cce4ecfa1ab970f8a344c"
    sha256 x86_64_linux:  "4a6695250063db235d71d0881b644a52a650e378ec3d26ae6c75bab60e664279"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
