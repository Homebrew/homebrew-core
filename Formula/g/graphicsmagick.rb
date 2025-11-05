class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.46/GraphicsMagick-1.3.46.tar.xz"
  sha256 "c7c706a505e9c6c3764156bb94a0c9644d79131785df15a89c9f8721d1abd061"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_tahoe:   "08abeb4f1f53226a4c315cdcd2693014875979dd19f43d13acd8f38945acebe5"
    sha256 arm64_sequoia: "bef5349a1eefbc26068c38ba3e3f2a312942f28d6b3b1a3c8b71203cd725aae8"
    sha256 arm64_sonoma:  "4b0fa911c77b374ce37b8b098d94251b322f7621e8788184e23b45a53c55fb8e"
    sha256 sonoma:        "76d18d26ba1b8636a7b3317f5d626cbe3e0a67d970b4c57c030293f5720c7d39"
    sha256 arm64_linux:   "e106299c99dde8a68452e7cb12951ce29c2ab46c91461e237ec64d9b8194bedb"
    sha256 x86_64_linux:  "35de5ac2dba284652fb8066b9c5cbfde3241701ad99452577400801be0d48b5c"
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
  uses_from_macos "zlib"

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
