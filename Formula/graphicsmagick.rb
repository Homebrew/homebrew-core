class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.33/GraphicsMagick-1.3.33.tar.xz"
  sha256 "130cb330a633580b5124eba5c125bbcbc484298423a97b9bed37ccd50d6dc778"
  head "http://hg.code.sf.net/p/graphicsmagick/code", :using => :hg

  bottle do
    rebuild 1
    sha256 "f5d9f2e78344f2cbe8fa1b2501fad25a197f3a9e494391ba6cd9ad0061d06b95" => :mojave
    sha256 "3b4c0a4ac3a704617fd885c00a36dcd92d18caa1265da2016c7da8a80ea948f4" => :high_sierra
    sha256 "dd3e5e9c22e07ce195de6bafc066b11f39a07e9b291d820f4a6fa5ec1bc77794" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"

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
