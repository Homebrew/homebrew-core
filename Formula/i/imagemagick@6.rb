class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-10.tar.xz"
  sha256 "1ee6ef603f9bb9dc10702b2bb83233e0a7717751b6f650c33f4e9daaf4816eea"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e0f1b81c2c77187338cf43611251513faa1a3ce40cb81111feca05209bbaf6ec"
    sha256 arm64_ventura:  "ff5cec3eb48eda19e52bd96bb9305cb597fca3b5203588d6de600e19da4ee28b"
    sha256 arm64_monterey: "4ee67b03ae87d735ed91c6870f112beb56c5a1c03f597e54f951a0d645e65927"
    sha256 sonoma:         "eb869bc1a05ab1d3f5755f43174eee8b1ec7b0b0b9afc824622aa247d14a84f1"
    sha256 ventura:        "c772ba9cfe1472723bc2d71fdca2129676f73c8662623e555e74e89c2e2e8979"
    sha256 monterey:       "86b717ffc25e136e9917b7cfb1d0d00aab396cb77522bb5865b57df005963f47"
    sha256 x86_64_linux:   "b847ee22042cf53a4282f41122e2127eadafdf8774f8f73e439b10ffbc3fca34"
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
