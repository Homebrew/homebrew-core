class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-55.tar.xz"
  sha256 "694f8c4482425de71a09daa46bcadf4bdb09fea0cd71bc6dbdaea9d5a004ef06"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9f48c9b141bd231f4f2a38171e46a2873ba7b96b76cf7b7736461e317dc69451"
    sha256 arm64_big_sur:  "df4bf13713e13311788767c5e2881d773fcf21b6dff1d15c8283b162f11c3819"
    sha256 monterey:       "6b6b4c37be101235b7c145fc97a6fe5314e701680cc08a9840ec1f71e1c09b8c"
    sha256 big_sur:        "042e378ddac7221442575a6988312347b9a40182a1d66cca265091b66d14c57a"
    sha256 catalina:       "e47bce6f86e4763e455eb32a7a0d53a68e7e96d641064fb380f1e73cc5cd9860"
    sha256 x86_64_linux:   "a0b2f9ccba50488ddcf9a7e8b01ec31d6b65a2c5686f84ac5e9e236336530370"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --enable-osx-universal-binary=no
      --prefix=#{prefix}
      --disable-dependency-tracking
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
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
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
