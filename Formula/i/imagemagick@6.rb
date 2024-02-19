class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-6.tar.xz"
  sha256 "e8ca8acfd57e2bc28b265522b7fa112914f9a887f07d565d2ef68fff74815416"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a743c9353d555578a4b794e241d885110094dfd5303e9a64ed4dce778a6e8f25"
    sha256 arm64_ventura:  "5436e276f379fd8c5df402191de3f622d2c4f6937af0b080706b05a48a76a923"
    sha256 arm64_monterey: "988134c1e0e24f53b525ca2f74a9b3b0fa0714e83dce8740982023003875d1f2"
    sha256 sonoma:         "de2c88c53dbe51ffb45c9fcecd1acd7c5a370b0e0a6bd91ab25341b01909a53e"
    sha256 ventura:        "70195aeb5cc96af088ff170b4bba0e29cc46ae013ce1de00df9efe364621ec7c"
    sha256 monterey:       "f06dbefcec7fb0d755a8d1d65148912a6c2ec584512673653b303a6a9d5d3e97"
    sha256 x86_64_linux:   "5c31ffe94d863a24cc920c7424697f9679b591e0a117fd94f8b5257d0864764d"
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
