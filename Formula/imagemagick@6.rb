class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406-6.9.10-84.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-84.tar.xz"
  sha256 "42c506071219024aae9a75baf9c12699dffa45885a1d3c3062a8b2368d0f67f4"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "e98789c276820364ecb94f29d5a0854f583877c5fe77f0f45292a55e6b674e8d" => :catalina
    sha256 "951ebfe244a5502bd7d58ab1a3fd776ca7fbc9188961c2d734a9659218eb8a04" => :mojave
    sha256 "fb8ad3ad98c0b3ebc2ced31d132ca145bbc5fe6935b4e2071686bcc3aeef2bc0" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
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
    args = %W[
      --disable-osx-universal-binary
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
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
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
