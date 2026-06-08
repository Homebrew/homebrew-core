class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.47/GraphicsMagick-1.3.47.tar.xz"
  sha256 "95fb682dab0206a9db168d065963f4ffdf5a60b0b2a375aca1f4492fb18d0627"
  license "MIT"
  compatibility_version 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    sha256 arm64_tahoe:   "e721f8ba04fd44b2c5626fd68138b9fe36de9e84e7c7cfe776637c066d26d8fd"
    sha256 arm64_sequoia: "ce698ad238da03749a16706504d43505a2f63e835c6d4266fd2df5be1cb02bce"
    sha256 arm64_sonoma:  "94749785dc6abb8f0d9f6bb2b09cdb5075d8d395d8d9e5ded657e115b188e266"
    sha256 sonoma:        "40d00eff452266f1141ec1d14a241b6e2fe1f0b26835adb5a18627c90c557613"
    sha256 arm64_linux:   "295eac51ae04881f68c2b9b93035c5bf47b0fa03f19296469546d0aaf7024a3c"
    sha256 x86_64_linux:  "f0318555cc66f82ff4fdff317bc5a16a901682cf118d14a440aeea2663c5b312"
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
