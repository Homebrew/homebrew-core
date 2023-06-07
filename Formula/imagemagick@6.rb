class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-89.tar.xz"
  sha256 "aed7ca2a82e759f4d90a9d4d8d5def28dbeb12f47f523cf9a63517f8e43eb989"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a8dcaa45050de44b41da8591cbcec7613cb3bfa16b460654ec0877ae7d0f6c36"
    sha256 arm64_monterey: "54d95c4b4ef144bb58f4270dbb4ccca409851e9728279ac1d54c3194a9398024"
    sha256 arm64_big_sur:  "9c7041e747ee82357aecb5211595d8bdf6375e6463be92f25923950674688980"
    sha256 ventura:        "b6aa5c842567ec73328eab148ba9df494ca26623fc960ce6961bea89bd97b4af"
    sha256 monterey:       "7617b9f6add9df7cc75f6eb4ccd2c5342cefc8bcd7424dc7600e234a162f2c41"
    sha256 big_sur:        "e21a68d06f0c21fc5da374e5a85e888817bd51c8c4dd84fd834a136b6b9ddcce"
    sha256 x86_64_linux:   "e2c52477df73d21b5a83c0706667bdce4b407e6f09445998fe39ba2b9ee1a63b"
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
