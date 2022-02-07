class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.37/GraphicsMagick-1.3.37.tar.xz"
  sha256 "90dc22f1a7bd240e4c9065a940962bf13da43c99bcc36cb111cc3c1a0d7477d4"
  license "MIT"
  revision 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_monterey: "423213e0b36e1c6cef66354fe96f3c1c13f0836a4c5bb8ef299fc5ae90740ace"
    sha256 arm64_big_sur:  "05f9bae927f523a7caf3361fa586f50de4e0eb55ae2a7a0f10d53f595955399f"
    sha256 monterey:       "384b3a9c79ff6f43dba2aa78901508e1da83613186bb5be62a5e919f51bbf861"
    sha256 big_sur:        "aadaac4b71080d30c8b0f739daf79e30dd90242026f6135ae8768813b77d7126"
    sha256 catalina:       "60bad058e0b8f8b8cc435d9137438af97e8882a412a350041174a6c810592c05"
    sha256 x86_64_linux:   "3fec9becdeecbae0e6a912756a5a1b87c1323ab9308b05263bccd67e25cb7cba"
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
