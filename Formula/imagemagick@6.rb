class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-67.tar.xz"
  sha256 "62a0c8bed8f29691bd142fa2c7956738e2ca96f6dd55cd9173337f79d21d7fd0"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b807e4b339e59640a3873673ecc1c067402c73f0a4e6505c6e28860f9f482553"
    sha256 arm64_monterey: "f2f1e6da2a334fe588bc6c923a3be4e90d79ac86fccb8385224447b9df7b05f3"
    sha256 arm64_big_sur:  "a9cb917ef28ef20eedb33209370dbdfa2d9b398e06f75d119d9d2d16a1d34e95"
    sha256 ventura:        "74f25d6908651bb9b8a81853b13ff1f92490086134a1b8bf72e575c7b7e58acf"
    sha256 monterey:       "4d6e66f1d958d9603adb1ae38ab08209aabae2b6daa9f1a8e1b5cdff56e02dca"
    sha256 big_sur:        "7bde40414133cfb90b079bfed897a3551c1b93d857a67e4a074f91f3c32c2e1f"
    sha256 catalina:       "12f0c6e9c78fb0bab94987fb5e623045822cceefe494c3fd2bc1cfd64fdc3b25"
    sha256 x86_64_linux:   "287caaadba954cfcf02c78d7db0690a450e43c3925089eb134045614c76410b9"
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
