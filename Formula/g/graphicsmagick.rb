class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.41/GraphicsMagick-1.3.41.tar.xz"
  sha256 "b741b11ba86162db4d4ec1b354989a773f73c40722d1148239f6c69c9f04a6aa"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "4f124e242ad6316aa4cb9015d5fc093c44bbc345199419909baf634f771716fc"
    sha256 arm64_monterey: "c1c6f774744204a02932a710f27398e2c72ced67993955199c7fabbc46a62325"
    sha256 arm64_big_sur:  "fe2933be797bd6c40264071d4597e3d83046ea58737cb4b4f6232f634f1f0668"
    sha256 ventura:        "9ce44c958b0871720b818ecfcdb550432effc6058ac61fff876488683d6bb68c"
    sha256 monterey:       "2c7153e854059e7715c4d8d16cbefda41925c86167ac2d1d4765c20d1d94cb50"
    sha256 big_sur:        "e52498494fc7fd930a60475225ef1245ec2aa680b23552aa1587a9863ff49d90"
    sha256 x86_64_linux:   "6c518a2ae30ab24cde772fd013b31b84751264ee663f08fbf80a9e005eaa6b86"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  skip_clean :la

  # See https://sourceforge.net/p/graphicsmagick/bugs/718/.
  # Remove in next release.
  patch do
    url "https://sourceforge.net/p/graphicsmagick/bugs/718/attachment/002-tiff-transparency.patch"
    sha256 "e040ba17c50391d03322e9f47ca5876385e8f1a984ec96856276a97f2794be16"
  end

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
