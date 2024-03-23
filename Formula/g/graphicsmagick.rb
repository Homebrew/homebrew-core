class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.43/GraphicsMagick-1.3.43.tar.xz"
  sha256 "2b88580732cd7e409d9e22c6116238bef4ae06fcda11451bf33d259f9cbf399f"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "143e614c74346301ca2ea5184eb12bc341ede5a857ee7d8376db6ba2c351775d"
    sha256 arm64_ventura:  "2d0c6fbcaf499d7e3f88f7ad1faed386505d2b1c2ed834325cda01dfa65a3658"
    sha256 arm64_monterey: "6414650deb92aad45128e73dd3915f49e5060f9efe92fad6ef0efaec85612f62"
    sha256 sonoma:         "47bdb7effd130ce0335a4456ac59891ba24efef266a07484889764660d8d4588"
    sha256 ventura:        "bfa12ae1ec6863ecf89525980eeb678429c3c107ee14893c52ef6d69b0bfaebd"
    sha256 monterey:       "3060c0efd9b1fe8a838b7c64f105fa7ad42af3148e13765a66d766a05b5e4a21"
    sha256 x86_64_linux:   "602d33b627591740d12f6da5a1fb5c864d177c613d514127f92cdd601de6637d"
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
