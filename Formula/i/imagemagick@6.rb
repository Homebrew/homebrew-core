class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-96.tar.xz"
  sha256 "570419d87cc8f22d36a038b4a91de349b181d3c23cfbedc241f89789564402b0"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d5fcf314adfbe1c8f7c694ed75d9c0477e4ebda134cbb10ec8c13f3b47b5a577"
    sha256 arm64_ventura:  "c533e07298a9f72d32e6df01dac0161234c35ceae477e6520663bffab360ece8"
    sha256 arm64_monterey: "4b1120c9913a07b7acd63e8b88a61b546b2b2e7555a2490be127ed1e847482b6"
    sha256 arm64_big_sur:  "adeceecc8b01c21fe11f2059c50f4b47fe5a54289a98e68447c4c216068557f4"
    sha256 sonoma:         "6cce60a322699019375f1399b4e080294917869cd2e165b6036d6c0a27d4ab91"
    sha256 ventura:        "9906b2e4d797b835405c485e053b945fcc452273d6ddf60f38a972b4be0d305a"
    sha256 monterey:       "1ebc697d6561e66a9bf8ef1581654e559e46a699e6ade5ce07f9ff15f547c15d"
    sha256 big_sur:        "b1a1ba209a529d825ef47de53e169b894fb61cd2fda73033edd6931b80032745"
    sha256 x86_64_linux:   "2535e2a6affec57e09d7488a0f106e58f1ad97258ba04e574c6af187869cec3a"
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
