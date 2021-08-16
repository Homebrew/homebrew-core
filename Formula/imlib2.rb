class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.3/imlib2-1.7.3.tar.bz2"
  sha256 "158d0b8c20bc11221af9e77a64a116fca7051b03cdea2c4f31d31f469382f997"
  license "Imlib2"

  bottle do
    sha256 arm64_big_sur: "007b2a5fe1988a71c0b777005279529fc3ff424e93ddb245506f3e33f65f0d0b"
    sha256 big_sur:       "094ebe201daab125409112a9ae7b94439409e8bba008fc6aeb47095b90a52ad4"
    sha256 catalina:      "74a5fbf8693ed51834ff3739d231aa0c9e515b232b5493aaa24936f7ee91173d"
    sha256 mojave:        "a86557a75ee60e00aa9443bb0aa04832f071b068d8064cf23c78e5c2e76169b5"
    sha256 x86_64_linux:  "39bc543b39068aaf137b2671e8eb8b8609f0e809a36a445ab85cdfdd24782681"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
