class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.36/GraphicsMagick-1.3.36.tar.xz"
  sha256 "5d5b3fde759cdfc307aaf21df9ebd8c752e3f088bb051dd5df8aac7ba7338f46"
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  bottle do
    sha256 arm64_monterey: "00d636c922ae51de90a6b80fcf86a349a54e4f1f26bbab3dc4b0192824dda0b9"
    sha256 arm64_big_sur:  "baae9073b2475351eb1d53d23fa0c2fcf75a1611649b3be229a71b693881436e"
    sha256 monterey:       "671c7fccbc081328ef68e28fe6e129463a2855d7cc4da12e438a5bf5094d63c2"
    sha256 big_sur:        "e8423e130f6dcdf83c501db944a341257e5b774cd007e1300f8b3cd3d32cafcb"
    sha256 catalina:       "a09639dfb381b06df090e595f6f1bc343c3619c9643de26c6cfea4073c9527cd"
    sha256 mojave:         "40b04368925d79d6e6fbe76014e5db18c7378eda414beb1b41de9bb8db6a69a0"
    sha256 x86_64_linux:   "c8be14cb6bc71dd149d6ad2b49941b9192d375e66b011c99decba30e8dae6438"
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
