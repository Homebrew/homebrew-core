class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.0-52.tar.xz"
  sha256 "49acbe467ae83488f65ce4fc023dd4d545ec52297e4d653b0f64683aaef30586"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0969583b20919881a52913e94bcfe528f99deb35e30b9576d6b26dc282b19982"
    sha256 arm64_monterey: "6bba078a1b6d9c200d3cce7b36e64ef2339ecbb0909f2bde526c24e3cba3b2f9"
    sha256 arm64_big_sur:  "7f030a99ec12a42d85e0eacdce461536eb953fc51f92abf8b95f302c96319ae2"
    sha256 ventura:        "7e536941e68a8fccf13377dbac6efadbaf4e389aadf61ff0f0fbeba246a38889"
    sha256 monterey:       "579988a566a21e3b4791cf300edb6878d230e57d3d8b25bd3432f25f3cec9d6f"
    sha256 big_sur:        "f2c5fde79f832601228a23bec0132f0b40d1ca37928c300876ea7ff1f00fca3e"
    sha256 catalina:       "0a30467d42ec6e7e4a57c5d3500b4abceb4aea7d897395fd5004e957444fdad5"
    sha256 x86_64_linux:   "a6f7beb9c79b59cf2475eba8ea90c9ea6d5efd675857b9f34f6f9eee2a01037d"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "liblqr"
  depends_on "libpng"
  depends_on "libraw"
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

  on_macos do
    depends_on "libomp"
  end

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
      "--with-raw=yes",
      "--with-gslib",
      "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
      "--with-lqr",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--enable-openmp",
    ]
    if OS.mac?
      args += [
        "--without-x",
        # Work around "checking for clang option to support OpenMP... unsupported"
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp -lz",
      ]
    end

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")

    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/magick -version")
    %w[Modules freetype heic jpeg png raw tiff].each do |feature|
      assert_match feature, features
    end

    # Check support for a few specific image formats, mostly to ensure LibRaw linked correctly.
    formats = shell_output("#{bin}/magick -list format")
    ["AVIF  HEIC      rw+", "ARW  DNG       r--", "DNG  DNG       r--"].each do |format|
      assert_match format, formats
    end
    assert_match "Helvetica", shell_output("#{bin}/magick -list font")
  end
end
