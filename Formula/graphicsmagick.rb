class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.33/GraphicsMagick-1.3.33.tar.xz"
  sha256 "130cb330a633580b5124eba5c125bbcbc484298423a97b9bed37ccd50d6dc778"
  head "http://hg.code.sf.net/p/graphicsmagick/code", :using => :hg

  bottle do
    sha256 "a661567129e2e78c73964ee78aa5f94c9357e4c3d6c416b95a8161aa946c5d40" => :mojave
    sha256 "f3cbe48ffbe0bb417757586fd3c0558ce30b587524e9c86e627a7aa00924f898" => :high_sierra
    sha256 "78b3e77bec0af70281edcf277efa3060c8e3a9d1730eaf3be443b4966ca71163" => :sierra
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
