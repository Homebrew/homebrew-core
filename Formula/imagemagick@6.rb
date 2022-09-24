class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-64.tar.xz"
  sha256 "57003a171b689e95de1a85f9201194715d7b6d2f2a6241a5efcbcd43f6768603"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7583a16d280e3135c71b7c5baf4c462a1bc59bfaac5722964f824d4c9a3b0f13"
    sha256 arm64_big_sur:  "8c52efde5762f5e3f8a57e0a9f9c7163ebc784e0952db00d5d01c1f85a2ac809"
    sha256 monterey:       "fd93a9766d7accf49db76f524fb4dc3e7bc3a72c5295508010c1f4d4269422b0"
    sha256 big_sur:        "ce28258ddaf557a7995a20f6f1f465f7adf35004f63800bdeeeaafff70eccf8d"
    sha256 catalina:       "633a8526af347a2ae8ff04d019607665fde3a932cb10d6d2b7c37e760b894c8e"
    sha256 x86_64_linux:   "a92946c5ec70269f7c027005a243a266bcf83e78844564e82c45ae8bc28b0f76"
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
