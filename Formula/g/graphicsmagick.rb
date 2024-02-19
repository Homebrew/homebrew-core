class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.42/GraphicsMagick-1.3.42.tar.xz"
  sha256 "484fccfd2b2faf6c2ba9151469ece5072bcb91ba4ed73e75ed3d8e46c759d557"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "8f4fc2dedd5a10715c9ac528e6d23d46693b07f785225267c38045571d5597e3"
    sha256 arm64_ventura:  "6e998339f8ffb7f41f27100fcddedbdc8f55ea6a2230edf8c130f9182980e258"
    sha256 arm64_monterey: "a3bc0439333de1a2f53c3cb87ddf935d9a494c0f3cec815be643b509b0aabe9c"
    sha256 sonoma:         "e77e95ec273f990ca0db6e2af42ad00cb5455a1c73e6d52b5817bc0a2f5a6816"
    sha256 ventura:        "2c5cfb8ebc865d8cc8ac2a5f55b3c5de6efaa628cd6e4867c890cdc1c160e887"
    sha256 monterey:       "41ffc1722969ff90b96e11efcce0b505f419b9d5acbce08e8c9465efb695db1f"
    sha256 x86_64_linux:   "442b218345e659d15e8e34b7355a1b685ec059ff71e6d87edbc2f0b3e1c52041"
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
