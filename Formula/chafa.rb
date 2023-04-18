class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.4.tar.xz"
  sha256 "9774bd1a7076ea3124f7fea811e371d0e1da2e76b7ac06260d63a86c7b1a573f"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9e61c049319056809071982e07fc37ee6c9495d91605e8e455bb6782117bf90"
    sha256 cellar: :any,                 arm64_monterey: "6f3bf8f30a123adc09b2d53dd9b92dcd7bc2e7a3e16ca66a47ce0cdaa40617fd"
    sha256 cellar: :any,                 arm64_big_sur:  "4a8789a498a01827699e09562c0def700b35f56b3c7935f7e2a2776bbf495edc"
    sha256 cellar: :any,                 ventura:        "753db66f6e50f9831e461eaa8c9ae5705d65c3b002116d01e2393dc52e6c5c72"
    sha256 cellar: :any,                 monterey:       "fcd32b538bf15dc50dd92e1235dcc858db73aa926f9a25e10dea705f4d790a6c"
    sha256 cellar: :any,                 big_sur:        "24c38006264a9197a776a27e61926614e22e2fd2115a63652a07cc908bbae621"
    sha256 cellar: :any,                 catalina:       "55e780b5b847d8856514efbaa2324e954bf8851cb691226c022dc79ca239b8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5074d47f7ae1d755a8ec38cbce925d629d8449823f925fcee793cd29186c0061"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-imagemagick" # deprecated in 1.12.0 and planned for removal
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 2, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end
