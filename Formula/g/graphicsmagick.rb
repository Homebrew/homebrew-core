class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.48/GraphicsMagick-1.3.48.tar.xz"
  sha256 "9218eb78179110f91371066ab75cb3b4dd034b9bb464b29ce9bab7a11979232b"
  license "MIT"
  compatibility_version 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_tahoe:   "481c9c58887488f22da63da3ac5a341bc639b38d9a0e86fdc3e7b5793c8a5f62"
    sha256 arm64_sequoia: "679cc0b4e37cab7320a52faf405ec78a10a7ca5aeb08e2bb223f79b13fd79668"
    sha256 arm64_sonoma:  "0bf22716d29638e4ce177d94cc8f824850046bfc43081c7944967ef357a234f3"
    sha256 sonoma:        "88a6ab88ab5a9149ad9a2e9ab72781b0da7d26d52c0835059592c2c15e455f5a"
    sha256 arm64_linux:   "5bc005f62219dc3149b9a3bf7a38211c279dba22aa6cc9c5b15c8caa8f761c77"
    sha256 x86_64_linux:  "54039a39d957ec59ebf3edcb3872ef59bd76cefdfd971b0777b6e901376e613f"
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
