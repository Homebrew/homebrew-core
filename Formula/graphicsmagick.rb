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
    rebuild 1
    sha256 arm64_monterey: "6390e9b63683aca9a120458a05cd405a7c1c15337b5521fd7b4a8ca7d5c9be6c"
    sha256 arm64_big_sur:  "ad3862da45b6d9a6cda022cbc8834d87c1ae1b04fceea068c0ec7da1683151c8"
    sha256 monterey:       "261c7ec6b275953638a14ab215063ceff80a6623dd3e9de141b06bf26cfc8586"
    sha256 big_sur:        "36c4193d99509ed03d316204042ba4c1225d62f625ca688917212c1dd3a8875d"
    sha256 catalina:       "c4625be268d468bf4387b4091026df9c2b83a160e63c596ef96db7edd8c85d74"
    sha256 x86_64_linux:   "7c4a3202d3ebb33933abfb9de51ece3e50960ce88b058cf4902279b6dc9a88d3"
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
