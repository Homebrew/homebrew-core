class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.43/GraphicsMagick-1.3.43.tar.xz"
  sha256 "2b88580732cd7e409d9e22c6116238bef4ae06fcda11451bf33d259f9cbf399f"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "4327a8a8fd2f1c697fb3d0ca2c701a9a66e295becf43c0a10c5add67907f44a3"
    sha256 arm64_ventura:  "c6c12c57731a5d6bd7a70da86e0a9cb468db8f7d8350a2ab07f22b630635a4e7"
    sha256 arm64_monterey: "c8d23bbcbe9421ad513d5455391e58f2ec8fc07967fc86660a683555436f38f8"
    sha256 sonoma:         "1a79f2ad8c106b7120cfb33f0f8208a0f392c39898b5549937aa52d680c2dab1"
    sha256 ventura:        "6f966005ea5b5482d131dacb7b3760340d99d1c922dd7ae57628276992fb5dcb"
    sha256 monterey:       "369d05d9066c18073da869dea68b0b7c6f20768bdcb9efb03ed7eea38dd755ae"
    sha256 x86_64_linux:   "340cf9139695b165618523c21eff0e0448950e6e05e965328c4142e85169f182"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-openmp
      --disable-static
      --enable-shared
      --with-modules
      --with-quantum-depth=16
      --without-lzma
      --without-x
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-wmf
      --with-jxl
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end
