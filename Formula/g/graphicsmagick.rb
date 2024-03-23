class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.43/GraphicsMagick-1.3.43.tar.xz"
  sha256 "2b88580732cd7e409d9e22c6116238bef4ae06fcda11451bf33d259f9cbf399f"
  license "MIT"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_sonoma:   "0e381f4e58aa3b359e8e67b1c498074c1e99f414f16b3d72b3e5c0a8e8768790"
    sha256 arm64_ventura:  "25962c0477d4d5a586677f071f025ec784bbd97f04d7cfb6d47af9d2d8b66c33"
    sha256 arm64_monterey: "ff7defdce2e26469cdd7fe3eb2a9e1adb6aa7727fbc0f123aef0ef00590e2758"
    sha256 sonoma:         "96a3ec593c14be38d54c6112fd2eb61494a67895cc1ede13643b954851de2817"
    sha256 ventura:        "48c7e7f1f67f2dba081e48ad378e84e2a0b92ca720750965a3b81fb64596d580"
    sha256 monterey:       "39c7e04ca7fd33dc55d7de30efd082090262f149a496a4e34efdab12281d56ef"
    sha256 x86_64_linux:   "e26fa2ea455f009f9c5e886f04036b6098811c3a023936fc23f60d86f713d1fe"
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
