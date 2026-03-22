class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://imagemagick.org/archive/releases/ImageMagick-7.1.2-17.tar.xz"
  sha256 "eb40bb5cf50cc3db5011fa242fa640065d60d61bec2b2b149a7a7891e21c9fbf"
  license "ImageMagick"
  compatibility_version 1
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dfe6bf9ce82601963948920246167ac35b0d979d605987e9ad3ba4c88c375835"
    sha256 arm64_sequoia: "9bf34139feb614c23d2f3d5d0799bc74acd0bcc84e44bf13b0231ff0a66a77df"
    sha256 arm64_sonoma:  "274e279f288a4d087393220669301b56e01489c117a7f266e7c19ebc01a1851e"
    sha256 sonoma:        "3bfec15a22a9fd9dc0302a4c74577f5957f127978ba093aecc80826d18b60594"
    sha256 arm64_linux:   "b7e5acc4f2b2cb3c50249d918169d20ef1d8dbaf0cbfb387810afdefc85fce02"
    sha256 x86_64_linux:  "657a380152cffc39185b5db18cfd9fe90103f7423c4e8e9ff1e17421533f3211"
  end

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
