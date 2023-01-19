class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.40/GraphicsMagick-1.3.40.tar.xz"
  sha256 "97dc1a9d4e89c77b25a3b24505e7ff1653b88f9bfe31f189ce10804b8efa7746"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "b0bafc8854f9f7b8fbb54553a614beb0f8158488ec0e311dd3dd1ef87a64fe79"
    sha256 arm64_monterey: "a8437596931ec5d6f2404ca81c05a64861a99457695f9130b9de525d24310079"
    sha256 arm64_big_sur:  "305cd1e588584b5f1b10cb7bb9811f0aa6e99fb646c24968f8e906f111b27d7b"
    sha256 ventura:        "67020d0a5c4accf346b836949cf0c85482cfa6b531bbf27b0acd06bec7b289bf"
    sha256 monterey:       "d27f686a2bbc904c9a862d8442c4fcc307823ac6d1b122a5605e292089acee67"
    sha256 big_sur:        "a5bb71478461411166840182d595a1af67227ab6fc0f1c56a69ab0d91f8bb7ba"
    sha256 x86_64_linux:   "8d8433ad727526734d430e4d8ad8023894e740e5551eb92894e3e37870c6b0b3"
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
