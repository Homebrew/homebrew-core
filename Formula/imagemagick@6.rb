class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-58.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-58.tar.xz"
  sha256 "0e1aa29fbf08a8d3eb9d429c609ea657f31b29300fb9a814388f3f4c11202dc3"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "d23c3796e4f7814437864856d2d168d66fd2676115459455dc61d0264daea340" => :mojave
    sha256 "cbc420ed5fe0a6a701268adbe06ce21625d8bfa91b742b9d9d072eb524f80ab5" => :high_sierra
    sha256 "e34ff7b08faabad8b0e519d3032b59f683588502454399721400b906c95d9afc" => :sierra
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
