class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.8-44.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.8-44.tar.xz"
  sha256 "1fc8be176c5196f7a7031a4d69ce253480172a0f4d9a4341882eabfcb12baa4d"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "fc95492e9fb3ec8a618a3535f29c97289ec07e03e47c0fbecc036ca1a9e70849" => :mojave
    sha256 "cf1645baf1084294dce6b1ec746a55cbe2c98617097fef743f509339ae242f6b" => :high_sierra
    sha256 "ccd7e949965aa5a8e4f0293efadb18a9c923b43090495d2727c3ed47508e3d53" => :sierra
  end

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
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
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-openexr
      --with-webp=yes
      --with-heic=yes
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
      --enable-openmp
      ac_cv_prog_c_openmp=-Xpreprocessor\ -fopenmp
      ac_cv_prog_cxx_openmp=-Xpreprocessor\ -fopenmp
      LDFLAGS=-lomp
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
