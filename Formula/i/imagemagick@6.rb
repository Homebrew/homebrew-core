class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-98.tar.xz"
  sha256 "05e3f1994bcd2dd35aad33739832deb5ac5a3db46b4bcf39c8cdc281d72ed7d7"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3420f5d5dc9629483f67bc29fb8c336a284231c999ef84a3dd9552f697b8f56b"
    sha256 arm64_ventura:  "a3152bc807c7f717da05540e2d5e89c79e5ba9c4c02255cef93051b607809d2a"
    sha256 arm64_monterey: "d716ee873e9fda86eb81abb7d2cc1f3be8fdf9883679bb6bc93c35048cfe282d"
    sha256 sonoma:         "1c04c84997426d90cb8e04fe796f84cd19dece6ee4cecdb6f32801977d608d40"
    sha256 ventura:        "83ddc3f4c1761a376f4a3accbb1af0998afd7999ce7eda4f192f9296c14cb942"
    sha256 monterey:       "844bddc52c6653286193a394f3de3237d270c0592431d33c086ebcc761fdb5b8"
    sha256 x86_64_linux:   "df80d27659a46a24638e142c7e567596a64ae090780f0855866daa8ce75d4c2d"
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
