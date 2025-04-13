class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-25.tar.xz"
  sha256 "17ba5ee0e0ce4a2248db5115d3683dd7c24e82eec96515da028997c9f926a121"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a884a93b2af4d61c53146f4059c6631862698370699f1b0e72440a63aa004c7c"
    sha256 arm64_sonoma:  "15eb0b4a426cc33f2cd99baf57017f9537d6251d29b8d09cfd7291fa6be85ea2"
    sha256 arm64_ventura: "561e5419e3167dba6d08dd98f4aca808124d54f101d290e01699972211bb85ec"
    sha256 sonoma:        "5c9d716152df5bff058f68b827de0ec536038302b9511b4a6b81eef630dac1d6"
    sha256 ventura:       "56d2bad5fe40d06ef7211974b8203bdf1b5d95758afb3c21b6cb6d78648f75f5"
    sha256 arm64_linux:   "4b17eeaa7ccab403f1cb8960e95b28aad76115aebba989edf44033345c3d5f8e"
    sha256 x86_64_linux:  "d9cf6be91ea016b35b0115117fb216f111f8ed69ca3132ff0078ae99dce207fe"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

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

    system "./configure", *args, *std_configure_args
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
