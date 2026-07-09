class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.47/GraphicsMagick-1.3.47.tar.xz"
  sha256 "95fb682dab0206a9db168d065963f4ffdf5a60b0b2a375aca1f4492fb18d0627"
  license "MIT"
  revision 1
  compatibility_version 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_tahoe:   "62033d1b7e15657add56057199e89d0cebce08a3000edd378f899123ab92e6b1"
    sha256 arm64_sequoia: "e09ac1c789eb3127e1df716765e29b2a805d3390a725e1611bdd7e43b54a279e"
    sha256 arm64_sonoma:  "f500db11975aec2d7abc2c72d7ca0dc1000ae1794306a70007f4082f2ebc8935"
    sha256 sonoma:        "174141a1621bbcc96c1fb6fbda788ba11ab9de74ef242f523655495589779502"
    sha256 arm64_linux:   "5ea16818315292e4943746c42acb99decfe6da8d59f13380f4eacf8ed7d62bd9"
    sha256 x86_64_linux:  "bd62e7412e941f18e60fd028d254f7e52c04b867f622f68aa9ae73a193d154b2"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    args = %W[
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
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end
