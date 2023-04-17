class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-85.tar.xz"
  sha256 "736cadaf65328b07c3d7d0bf11078bbd99fd538a3d348990091a7edcf6b0c958"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "221ddaf10f8076303eb51c1e832e1c68ba7ce39a78e910b61ac2371daa00217e"
    sha256 arm64_monterey: "eb7aa0dceacbdbabef0c83216369942eac83ae41d9ebc6e76d454923082c0a34"
    sha256 arm64_big_sur:  "b1cf8a6015216f1e83b2fb97f83f1294ebc60caf01dce551e9699d8e4e980255"
    sha256 ventura:        "e8179dc1ae4933da6e3bc08480fe8137df59114b14300e05186914baaa62ba1f"
    sha256 monterey:       "1d9e2dc30c6616a9987d22b4b1efe58a8bc80e18fe4c4bbfbeb748619452bdc6"
    sha256 big_sur:        "fa9dd75dad467d5ff76503e93f9897d6544c2c4ab4a9beed8c098a11c1733cbb"
    sha256 x86_64_linux:   "207ac926025e0f529dfd3cf216662f6e21a71f29c1f6e97d04636c4c74ca51e7"
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
