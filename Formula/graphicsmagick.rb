class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.35/GraphicsMagick-1.3.35.tar.xz"
  sha256 "188a8d6108fea87a0208723e8d206ec1d4d7299022be8ce5d0a9720509250250"
  head "http://hg.code.sf.net/p/graphicsmagick/code", :using => :hg

  bottle do
    sha256 "e5517b416b979debeafdf4fc7a408e09f77c2a8f93b76051d6707f2a6750d0c2" => :catalina
    sha256 "26ba769c14c9ab3b4de02afcb3735b4f1256f23e822166934152c68939508245" => :mojave
    sha256 "8d27e0e2ee2ce56c77a65d691ae893b1ac4ec38e62ee78111964023800756ac5" => :high_sierra
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
