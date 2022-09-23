class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.38/GraphicsMagick-1.3.38.tar.xz"
  sha256 "d60cd9db59351d2b9cb19beb443170acaa28f073d13d258f67b3627635e32675"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_monterey: "69c5aa5a28c4b5675addde198e3779134128ee132354dae82b9be85c5fab4817"
    sha256 arm64_big_sur:  "7e1ad64d06e3e1e310879361dabe3e8c66d4a8f4c645c6a9fc5b69d8168d2c6a"
    sha256 monterey:       "04b039ead7edb17e0da005dd679dfe51d886dc34e481aec4d3df0f5951d0836a"
    sha256 big_sur:        "b9bf139790e2854a0d1c510af638fa31acacf6e809dcd1b71b940a5a3eb8bb2d"
    sha256 catalina:       "1696c632ecb433129619bf445cf5dd9e227389484c5ddd87dd1ce744257dcfcd"
    sha256 x86_64_linux:   "ff6447deef369947c767bfbad348e28f882e753ebbea58ad9e59dbea0446cb2e"
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
