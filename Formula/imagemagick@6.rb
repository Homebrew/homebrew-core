class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-29.tar.xz"
  sha256 "82cd5c49e24d1b680d1be054ccc59dc95cff014ec91fcdd4121cdb9e140aca84"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6bb07c71b71375f8dd08b56e43e3ee1880035ad723b40f86317313c608aac2bf"
    sha256 arm64_big_sur:  "8beeb2d90c5df09ed6a7d04e6b1efd26c297f80e86b281654b4f168f990f0927"
    sha256 monterey:       "9d5d2288ef82da671bf56856ca66bd381c014db68999ea774f228f5c6cacbdfc"
    sha256 big_sur:        "f06ca31bf747f5ed8aacbdb9d82c3dfc993b2abe7392da81142ddb25c7b2f57f"
    sha256 catalina:       "c512f3ecd73f50334bea399a1c02151a139579c2c31120566d28bf531c1f9925"
    sha256 x86_64_linux:   "16f232e549f9a8922977b4eb992ce3785b7bb8ab90abac26d44b98543a04e259"
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
