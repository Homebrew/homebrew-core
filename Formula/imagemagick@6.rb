class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-18.tar.xz"
  sha256 "518deb588bc9c0b767acc76f196c4f8129a4927c086df9d9dc7fd96e953ed6c5"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "12de2ef0df830eec6435458d9a1be82d6da179d39a914130954f82f83e413c9d"
    sha256 big_sur:       "db8f3ead310d086248eababf0b11973a3edfcca4de9caef43b75a188072d9218"
    sha256 catalina:      "c04c24b5cf3902a57676cc9195d3003241ad101abf060221f56f8154a8d933a2"
    sha256 mojave:        "19f9835fc9a4193d2c12bef48197fad3ba8f6559092f4a313b28b12bbbe10f91"
    sha256 x86_64_linux:  "d401503d88e42ccc48a426c4eac72947b47073d4ebcdb5522b0a0841c4de215b"
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
