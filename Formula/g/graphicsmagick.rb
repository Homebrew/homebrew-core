class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.42/GraphicsMagick-1.3.42.tar.xz"
  sha256 "484fccfd2b2faf6c2ba9151469ece5072bcb91ba4ed73e75ed3d8e46c759d557"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "20cfcce4373d2e2bfc32537b8bd347f323321df60dbf647c86903de5ffcf52f6"
    sha256 arm64_ventura:  "1ec94cdffcbfd37a3a3eeb6866923057cc84bcec3bd58f941c113bdabb233e5b"
    sha256 arm64_monterey: "b6b182bb4d7325d802322eeca0f42352b194c9edb23e295827957d67119460d1"
    sha256 arm64_big_sur:  "6e7c652dad9bc24967f041d6437990a56b4e7b9741c9f11702fb4d67c22d6103"
    sha256 sonoma:         "63e670f5859d21cef1e61e5118f94d31e8fdcb3e7beb9ff83f9e3eaf32c6b4c4"
    sha256 ventura:        "d54d90d88dc4a69dd55c5e5ead34ec679cf5802fcb9346519c46142d36908169"
    sha256 monterey:       "e4c6162c23798a781099a760f8feea4ca1cc94335caaaffce5bdf6171a317910"
    sha256 big_sur:        "0d9a8cab31c155b1b5525508f610a3ccd5881ebd75a740ac7ba80ae84dfec7b6"
    sha256 x86_64_linux:   "6a0e18561264f883a58f8ed373d979900a6d2c348436b1c8d112f2aa4eda405c"
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
