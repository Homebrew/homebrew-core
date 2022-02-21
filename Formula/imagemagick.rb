class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org/index.php"
  url "https://www.imagemagick.org/download/releases/ImageMagick-7.1.0-26.tar.xz"
  sha256 "5eb5e48b5785f2e8042563019694f70f09c33e81672a0570375ca0d56e07e752"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0a194c1c9e7acc383e3402fd630cdbd5084ddc1e43d36c402dec296f19108de7"
    sha256 arm64_big_sur:  "e5cd97530d5c8fdea1231c073793545284438f3040eafca1abc31a6870026754"
    sha256 monterey:       "f9c60315e92c7501d001123e76a38780162d5317cb5929b80b4990939152a275"
    sha256 big_sur:        "8cf8ba6ab12fe45b24b449080f1c5a941ae587f1ed0d53966edd07c6cffbe353"
    sha256 catalina:       "8ee01809ffacd81d3cf4bb725e373a14672909514b56dfb1017eb9e212f07132"
    sha256 x86_64_linux:   "0e3836f2b45011f603a9e3a2bc7b195fc7e7e598321572abc7aaaed8f8d31736"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "liblqr"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = [
      "--enable-osx-universal-binary=no",
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-freetype=yes",
      "--with-gvc=no",
      "--with-modules",
      "--with-openjp2",
      "--with-openexr",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-gslib",
      "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
      "--with-lqr",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--enable-openmp",
      "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
      "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
      "LDFLAGS=-lomp -lz",
    ]

    args << "--without-x" if OS.mac?

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
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
    assert_match "Helvetica", shell_output("#{bin}/identify -list font")
  end
end
