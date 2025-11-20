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
    sha256 arm64_tahoe:   "594e6dcbe8a2133923e5a518bff3b2ee014f65c3bca0510419ec6b991009e8ef"
    sha256 arm64_sequoia: "60263b08be05c26c462bda03c8bd4773b48b70f9bbcb1827e927456d3df1271c"
    sha256 arm64_sonoma:  "7132c91fb90ac0e7bb034c7577f029f429b6105653364b4755aa94d7589fe065"
    sha256 sonoma:        "1af4ed6c2e8bf56388ad49f020633cf99ce956d6f2fd017789dfd7a2344901ae"
    sha256 arm64_linux:   "487dd832dee050507bc08b53d59daca21878e2794dc3a23e84dbc78005f14f66"
    sha256 x86_64_linux:  "bee74e895164a855d8f46dfa47c74b6d0fc8d2ef2501d970b2740c43506be092"
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
