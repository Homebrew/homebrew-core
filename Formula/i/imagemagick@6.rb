class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-7.tar.xz"
  sha256 "2a521f7992b3dd32469b7b7254a81df8a0045cb0b963372e3ba6404b0a4efeae"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "78a494e527518a43308e3fcb4c0255d4a64906c7aa05ecc19bf87044659462fd"
    sha256 arm64_ventura:  "49086fbb8b989e42afcee0e063096d6db52d3000082092e1aa45d3e04f437a51"
    sha256 arm64_monterey: "b5347656131938174aec6d3de768f7e8c0d17e7e955cd0c7b783aa1bf5246cb8"
    sha256 sonoma:         "27751213b6346998289a3485a2ee020322cc479fd3c570dc44ab14484cec7c15"
    sha256 ventura:        "dea98d24824b15c55845408de781a1d29e93072716518d3fdc58b4e555c9e7b6"
    sha256 monterey:       "adbafc008b29ad127b2e7198b79bbae79cc6d4ddf3d5a42aedd759a1c08d4e55"
    sha256 x86_64_linux:   "3d26df21777b1765b18e011843e5f131e27ea35409a43d1492ad8e40e5e684b9"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "libxml2"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = %W[
      --enable-osx-universal-binary=no
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
