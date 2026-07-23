class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-27/ImageMagick-7.1.2-27.7z"
  sha256 "dcfbdd8294b3ad6d07fc0edaa2c2071ffa6085b1207b525929b70ffb067300ae"
  license "ImageMagick"
  compatibility_version 3
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "01d68248f56f8fee6e270c8a415f5392f569485d5f7c7261056bf7db90e24add"
    sha256 arm64_sequoia: "f78f4b04b0a0a6c10813d75c878812359c6aed6233d92a4a59ad54ffadb6a5c7"
    sha256 arm64_sonoma:  "a596c102a1e788f90d65466b62d02209c3f185cebddf3d37a462726686e3fe17"
    sha256 sonoma:        "7ea98aa0aac1aae9597dedb2a10abc057282cfb03f72a9b9d355a27a88ab7419"
    sha256 arm64_linux:   "63a45e8701a90f06ddff967b402d9a36b40d8de55a4120bddc2572c6c1a6b02c"
    sha256 x86_64_linux:  "6ee7c694eb22e68733a1b11cd7617fa9471c0ab8705ff8463c367fe81e3e9e16"
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
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", formula_opt_bin("pkg-config")/"pkg-config"
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
