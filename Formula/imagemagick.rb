class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org/index.php"
  url "https://www.imagemagick.org/download/releases/ImageMagick-7.1.0-22.tar.xz"
  sha256 "8b02ffda73a0163a8341638b5603d955ff7258798d8d0194577ffa928cbb97a8"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "bc62aeac76262d51a54f615bfec2704bc2d48b3ee1c8c1a180508b72cc4dc6b3"
    sha256 arm64_big_sur:  "6bd63775dcc2d1bc722e84b3a0eaf0ddf9a7b350281a2711d2a2f38ade636893"
    sha256 monterey:       "fe51b071b4c50d974ae66869b90302b89a67670a1942256ebe18502a02465e50"
    sha256 big_sur:        "c571499ea947800d1f71c47adf7d0e4e8ca2e38418fcb1f3503ff0435efa5c88"
    sha256 catalina:       "b3f084439c242753a08d09fb25da3a6897fde63133b017b693e7d0eaab912c49"
    sha256 x86_64_linux:   "7f7f88b6f966861f3dd905de486c9d8e531cf1c511710bbfc994d2249b15725f"
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
