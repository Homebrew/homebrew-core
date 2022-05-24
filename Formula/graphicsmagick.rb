class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.38/GraphicsMagick-1.3.38.tar.xz"
  sha256 "d60cd9db59351d2b9cb19beb443170acaa28f073d13d258f67b3627635e32675"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_monterey: "60a324b98f4e6a8015f0b304df612b70fb64b5f51ad2d43bfcddfb951257125d"
    sha256 arm64_big_sur:  "17e64fd18bd459648e31e463e6765fc8a39496324c2df9b977ce7b6d27ba77b6"
    sha256 monterey:       "4aabbd3fa3fb9a3dbdf111d2d06cc1b78bf8fdfb8f1ea9f440aeabd6f40e9627"
    sha256 big_sur:        "357ff0c2523d8015ec3000ad3aeca4b474c5816cd055ed3ee2435200ba580deb"
    sha256 catalina:       "a7138441a365f8cb115b325d30f462e5ee1e5c9ec4454240cadf6cc7172be8d7"
    sha256 x86_64_linux:   "77642a448d7ce30d4324b45eb0ec62e710e2b9c6c813ad240d2a05a756360d81"
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
