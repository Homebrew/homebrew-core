class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org/index.php"
  url "https://www.imagemagick.org/download/releases/ImageMagick-7.1.0-17.tar.xz"
  sha256 "af4c2992b2edd7f2979a4bb26e4d47baf7ac0cce190ca1d4678fb4bd318d9589"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "71ae0a77271dab3a2b544e5837f7b181cb8402095fdaf59ab6cd11b8eab5cec9"
    sha256 arm64_big_sur:  "69c318f6817e3093ed91252ca90948e580d937943ce1cdf6ba75b6adf9bc2a01"
    sha256 monterey:       "c0943c60343d7d55167493640bb91d9dfd87b601ea6fd19109c0e098096d0fac"
    sha256 big_sur:        "8531c518d953f579047b28cacda35c41eaf3ea11925a3747e9f1799a8bbe06ef"
    sha256 catalina:       "134730e9940ea5ef2306771fb2eef93b3aa0cde4162edae27b9a8210fee1e75e"
    sha256 x86_64_linux:   "232cc8a4fd829a931586e70c1a89449a8cb390f17172a9aad3fdb837cc7a64b2"
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
