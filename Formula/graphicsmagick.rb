class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.40/GraphicsMagick-1.3.40.tar.xz"
  sha256 "97dc1a9d4e89c77b25a3b24505e7ff1653b88f9bfe31f189ce10804b8efa7746"
  license "MIT"
  revision 2
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "446e3cb08c86bb7de71f3c8cade78129d164b59eda6a487895bd5e4fafcb581d"
    sha256 arm64_monterey: "a4690f3c994060ebcf9f35eb8c1dda04d0c0b87e3dc33c76b0b9dc42b2ec8232"
    sha256 arm64_big_sur:  "f0fc2e65a54c8c133ba460c20dc6e5f9dd132a7d2e044df941480aed6c37052d"
    sha256 ventura:        "29e61a26f58cf53d311c0f2b286a8e3f05846ee60d29a6cc0c279e9f2b048420"
    sha256 monterey:       "3a3586f6d9aa5fbb3837678d99de86910442b762f9ac24e9725ee9117cc0dbf0"
    sha256 big_sur:        "f88307db7a99295947f897822880544492aefb2451274b298dc593886ff0e6ff"
    sha256 x86_64_linux:   "9872ca3b3cbc1411aca7ae0eb036a75904bc8418129b9b5f472d50bd25441e1e"
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
