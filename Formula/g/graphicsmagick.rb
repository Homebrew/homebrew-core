class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.45/GraphicsMagick-1.3.45.tar.xz"
  sha256 "dcea5167414f7c805557de2d7a47a9b3147bcbf617b91f5f0f4afe5e6543026b"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "f950843cfad9376677acb179ad6553531249d9e79b37a830eba929591beaac46"
    sha256 arm64_sonoma:  "8b521ea1cf171f8fdb14b43f3b3d06699280569791a25d64aa73684062e06ed0"
    sha256 arm64_ventura: "e0c9b6972e74fcc2d74037d907671ad6a2073553816beb11b8aacb9b554ec689"
    sha256 sonoma:        "15ad3752ebc129fe21f9da7b729c2d90cf8c40ce824dc42f6725d31c139d2896"
    sha256 ventura:       "104380c258558a7469b1b7133222740d00af867fe8d8a1dc36a419e6294a58b7"
    sha256 arm64_linux:   "f02609d87790a12f30af1c7ed66f719570109def8775379307962735bcb153f6"
    sha256 x86_64_linux:  "b6e2fea1abc3ea05bc6c9a7837b1e5fb2257a35155fe0c539d1e3008d257879d"
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
