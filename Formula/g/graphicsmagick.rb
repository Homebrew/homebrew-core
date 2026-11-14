class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.49/GraphicsMagick-1.3.49.tar.xz"
  sha256 "7efa070dc31116b4315061b39f84bc7181e8b060bf61214ec9af851131af9c81"
  license "MIT"
  revision 1
  compatibility_version 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_golden_gate: "859a8ab109c74c1bfafec8bb195b8982219e6a1c3f6b4e5938b4698f59520ba4"
    sha256 arm64_tahoe:       "99811e2ae94bdbf091a63ca5b24ede0126d09d3ff4a866c577e3d070265f065f"
    sha256 arm64_sequoia:     "12761c952da81986d3aaa5b8f89b2d1f7eaf74ac0521591153287792fbbbb5cd"
    sha256 arm64_linux:       "d9bec9f2a442df7064bf6a38dc62018e3d71d2eb9142053b07ebcc31735dbd39"
    sha256 x86_64_linux:      "e749159231d7d85f3ecf076988f71081eeecb9a9150a9440971ca109bddf6a08"
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

  deny_network_access!

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
