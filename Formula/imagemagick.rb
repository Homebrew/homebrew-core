class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.9-13.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-7.0.9-13.tar.xz"
  sha256 "c595da7bc601b289a4600cddd962bc666fcbf4bc8fc3c39c80f5c6764002668f"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "4dfcd646094ec847694aa6fb1bed486ae0c5f0ed86f43ab4e4dc01d1c539ebe2" => :catalina
    sha256 "573c6bb23f71c4ee52875bdca6d0a47f325213ff1739550ada37719029b8362e" => :mojave
    sha256 "c2698d49eff1a03d9e1aa9181e3213f47aa41c989dbff96da90aa08086163a08" => :high_sierra
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
