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
    sha256 arm64_sequoia: "ef8bf8d6a90c702a0dfb865e7812b9ba2e696db0c22ee3ca35b73e4e8683156e"
    sha256 arm64_sonoma:  "c91a420ba370579b309a2b7ad7b40a2cc4b67f075517c384a092854124ef569f"
    sha256 arm64_ventura: "72b50b7f99e67404855a0e158566d3e84959145a36318af47d5db7154f4a4f0a"
    sha256 sonoma:        "5042f6619a45c4e79788a23472f9f1472b4494924212eb57ed64e983b87af980"
    sha256 ventura:       "dd6d30c9b669b7a2ed16711fc71927a7a6673fa6ac5731a029e9074e8d2011f8"
    sha256 x86_64_linux:  "4c1b2f71ef9382074f6a0afc3a6f4d989a8b455df750494faf0f300df77699b7"
  end

  depends_on "pkg-config" => :build

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
