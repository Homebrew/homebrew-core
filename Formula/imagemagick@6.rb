class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-77.tar.xz"
  sha256 "3cde0149018098599610e7afaa28b9f8561f5fa428755fdeb87986b5fe012103"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "347ecb73aeb760deab1cc7d1da962991b6034c88c8a1a18098226d86eb5dd2bb"
    sha256 arm64_monterey: "b36d1c319462e725291d9fdaf62934e62a91a4bf966cddfe153396eda5145ef5"
    sha256 arm64_big_sur:  "5b92eb2679fcca46919e38546268f368b82d33a9d3be221855833d7039dd6c2c"
    sha256 ventura:        "e1edbea843b24fa7a8c101f6f37054e46fb1110e9b7112267ead8e1d07f9ef65"
    sha256 monterey:       "ad66eb6e3f94e2d7b9c10b270f0b662149b0e6d2fad7e61e27654e0ecbd386b2"
    sha256 big_sur:        "609d9e40336f274a476f4a10c23a52a0b40869ee14272d1f0ec4d01fbaa09153"
    sha256 x86_64_linux:   "1905b2c95f0c64b5e474a1cc6b918e13f00983517557f1efa5cef66725e34b69"
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
