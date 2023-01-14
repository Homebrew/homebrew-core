class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.40/GraphicsMagick-1.3.40.tar.xz"
  sha256 "97dc1a9d4e89c77b25a3b24505e7ff1653b88f9bfe31f189ce10804b8efa7746"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_ventura:  "35cf8786213d513dd4f992fbe0dd92a9242cfc5722132cb96a53efe5ef1f332e"
    sha256 arm64_monterey: "8e279fb2e6269dffdc6268c304632ac4ad84718c01751299759b6ebd849cec22"
    sha256 arm64_big_sur:  "109fecb48596bf2b02571761aa66e69b9b80d8515a0460a0e0fd8b3c53ad4480"
    sha256 ventura:        "77dea8c6cef1e529da7d181feb49ee9f1d9f5c3094a14453277ee3b932473839"
    sha256 monterey:       "350a28fcfd5dd7bce571e8922ce38af74dc0fbb92897f6b81762d378806d9b19"
    sha256 big_sur:        "034a0dc30d4e8107b183c2438e8911f6d8ecaffc96f7ff8598e5660fcf89ae8b"
    sha256 x86_64_linux:   "03b091052b63deae7e63fb4924579e050063cbc03a3ac989fd3b9d69d251a5a2"
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
