class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-22/ImageMagick-7.1.2-22.7z"
  sha256 "145e1527f24e2319a8b908567cc6cff603871a4ff00650a63a2fbc02670e4cc4"
  license "ImageMagick"
  compatibility_version 1
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "e6bbd22ca1c2e58ae8adf04a18632de056775a3b1212e9573b9619e7e50fdcff"
    sha256 arm64_sequoia: "3a473551af3270d01b27814be5e58848db2e4a0db94a86fe2320ce576fb8662e"
    sha256 arm64_sonoma:  "7e1b3911c8f22300ffb29980d5bedba50191c6689d5dbf5d1b394e05a1ea550a"
    sha256 sonoma:        "7deb215e96cc386989cefbf76b958fcd9bb6ef2c99fe1327a99f95dc375178d3"
    sha256 arm64_linux:   "ba410c5b425bce7741aec3d0bada369f1665d9d24047237336203a3408ead256"
    sha256 x86_64_linux:  "93eb8a633e943c39980a6c63b482bcee9a6d5be797f06ad34983cedcdf469ea8"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core,
  # recursive dependencies or INCREDIBLY widely used and light formats in the
  # current year (2026).
  # Add other dependencies to imagemagick-full formula.
  depends_on "freetype"
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
    args << "--without-x" if OS.mac?

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
