class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.37/GraphicsMagick-1.3.37.tar.xz"
  sha256 "90dc22f1a7bd240e4c9065a940962bf13da43c99bcc36cb111cc3c1a0d7477d4"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_monterey: "319d87f145b215cba30aaa3d1f8833f52472b67807a298fa6b63f3277985ec04"
    sha256 arm64_big_sur:  "41b4e1a6e9820b8cdabfc6555c3d5e96fed52b54a447c91ea88863bd8954a25e"
    sha256 monterey:       "35116969eab459fc1e4ccc1562ea894ac1c78e1b8411b1770f8bf4c376dcbb32"
    sha256 big_sur:        "9b56a9e0cb6ecede62950218794fb88358de577a6dd78e8139a563e6c2e4c056"
    sha256 catalina:       "fbfda29e643b21b269279e144c1dcb060c273ec934a0ea7d9636a3bd2beeb63e"
    sha256 x86_64_linux:   "70d5ff183bc56898f699203a72988d7524ec1b5669432500e20aef0dc7e7c5be"
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
