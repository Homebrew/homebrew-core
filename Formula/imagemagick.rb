class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.8-68.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.8-68.tar.xz"
  sha256 "3639baa6ceb5db38b1b48a4b917f90fe007ca7edca1f7894d5555a0bc746305a"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "adc548891ac2f3cb682adbbf9603bd5b2fadfb0ac68dd982827bcc80a1a055cf" => :catalina
    sha256 "8bb0ae51e8ff5ecc22f08712a9ba5af1f08dfe26debef4cc2b54195da4de6268" => :mojave
    sha256 "6a85643836f2def3f3aad705f17dab392c6497ee4eabbf23ccd542617dc50922" => :high_sierra
    sha256 "ac7db948f4e3952fb560df507361590823cfa232d19061f629e8219d2531ff2d" => :sierra
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
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

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
