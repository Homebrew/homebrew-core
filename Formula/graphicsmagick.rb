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
    sha256 arm64_ventura:  "6cad7b1528f48c90f90405ef6f0454fa26d3c40009c4c71a14447fb3975babc0"
    sha256 arm64_monterey: "4f448e321cccf5fd8e9ebeebea6966f0ccd9a89342464f2ee13a6e3bd408b94e"
    sha256 arm64_big_sur:  "735f00a3dab2472727e8139de794355270736e7e3b03a89b4376b8a0ef7d56b7"
    sha256 ventura:        "c774245ed95564630621c594e43370159016257e43e87a33321b394175bfb3ac"
    sha256 monterey:       "c641883183a53def3bfecb1e39f98f85cf302d81c9c247691fbcd00542274a6f"
    sha256 big_sur:        "d33e9530e536396d5185cb8a9df360202c7d7f56828deac6529c087ba40f9829"
    sha256 x86_64_linux:   "fd501846245487c2bd0b26176df5a4611be490bc36ebc1fc86171ccb7eb74eee"
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
