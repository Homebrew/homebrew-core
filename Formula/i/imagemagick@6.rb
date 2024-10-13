class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-17.tar.xz"
  sha256 "f83ae219da71e0f85609f4d540cdae4568f637be7ae518567ec0303602f61ca8"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "f13257538272e13b12d7cb7c806d1dfa24be6a4769af9041c08fa41111259d5a"
    sha256 arm64_sonoma:  "cd1bd3370fea03645310e22fa7a6e6836c7c43784530073d453066eb9bb7bca3"
    sha256 arm64_ventura: "817735ec0a49054d574b9fc0e018ce0cac71591e6687cbb467762fb90fb10f03"
    sha256 sonoma:        "e7e0227f640c55a26cbd98c514815775b1a9e4427d6261d37b4256d048339148"
    sha256 ventura:       "173fe92a9ab0012ba16096ccb23ec69b3b32883f16b579d45c448aa5f0e4ffc6"
    sha256 x86_64_linux:  "09138096d1a9c5d6f88f605cebcfec0487bbe3dfc65a352986aac412adb49255"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
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

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
