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
    rebuild 1
    sha256 arm64_tahoe:   "6b65ffb0b494077277b0c9b654d1e2185cd88ed612a3ceac6f3c6ad5fc677cd2"
    sha256 arm64_sequoia: "194bbe7820974cab77ef83a827efa00af0bc2fad86e1f076dc20cc53861f138f"
    sha256 arm64_sonoma:  "a784999a5a54fe74fa72c6cc97c421993b3f22b6c54df621384a14269b4697e0"
    sha256 sonoma:        "2c1d774a217f0dcd8951cff4e1e93f397a1e6f8040cd4c37ce4134443c68c5c6"
    sha256 arm64_linux:   "c2769339084f247efba341dc9580863597526503ab5fc7ad96445e2531a54554"
    sha256 x86_64_linux:  "8053553100e6ffbefe17bbf8cf563937ed988da6723ca8522d80bd261a096b63"
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
