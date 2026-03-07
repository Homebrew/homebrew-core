class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.2-15.tar.xz"
  sha256 "ccb9913bba578daa582b73b2a97e55db49765d926cbb8ebf54e4e79b458e6679"
  license "ImageMagick"
  revision 2
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8561a40bcd9f85b38593d3f0fa20ffa44106f1e95a77706930d6a79540d2bb0d"
    sha256 arm64_sequoia: "4dc5a4725b071ba89a33fbbcf736d41e457bdcf6a8636b8de4e6cb9ed78e0f8b"
    sha256 arm64_sonoma:  "9c7e42c0c6b1a1a95c70f9a6649a7d3735d7ae295237f05cbda83395cd49e166"
    sha256 sonoma:        "099e49f2dfa96540d8c3a733cc4fa2200b063e5428f1905023bb9ce7e06f87e7"
    sha256 arm64_linux:   "7fb6d81ff60f0cc49468105fff3947bf9ad8e6e9ae27040e265a4465fc53d7e3"
    sha256 x86_64_linux:  "870a33b37d18cff41ce32fe0b42ca9dafc567c4379a2c793f4c360bf994f57f5"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core,
  # recursive dependencies or INCREDIBLY widely used and light formats in the
  # current year (2026).
  # Add other dependencies to imagemagick-full formula or consider making
  # formulae dependent on imagemagick-full.
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "imath"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = [
      "--enable-osx-universal-binary=no",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-gvc=no",
      "--with-modules",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-raw=no",
      "--without-gslib",
      "--with-lqr",
      "--without-djvu",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--without-jxl",
      "--without-openexr",
    ]
    if OS.mac?
      args += [
        "--without-x",
      ]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      imagemagick-full includes additional tools and libraries that are not included in the regular imagemagick formula.
    EOS
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")

    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/magick -version")
    %w[Modules heic jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
