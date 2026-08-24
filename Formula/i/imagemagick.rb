class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-30/ImageMagick-7.1.2-30.7z"
  sha256 "3ef82a66a4b28af069ac4f826ed958c17ad9baac6393368db7ec6d5920f6be7d"
  license "ImageMagick"
  compatibility_version 3
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "e4dc1c8ce8d4ace4b4ef8035bb1901210ea2dbbaaa657b4d33837e0c3df9ee8a"
    sha256 arm64_sequoia: "d37caa2095d1bc4fa706de9b0b6dc6e095d810fb0c886193144c21645811ae0d"
    sha256 arm64_sonoma:  "9d33ef2f40876425cbfd46608e7a6c9c04811b89cd700b1e27d2146e1960401f"
    sha256 sonoma:        "b72c5b2944aae1a7b88fc7167b365ad945eb972b60cbb730f447ecdce8567568"
    sha256 arm64_linux:   "beca67c63a4d7dd8168dce83afa5bd103a90303629b8b447ed1d870ba4585c34"
    sha256 x86_64_linux:  "8465fd0ff8e169910bb017b6effc32aebefc83f147970e4132c974277f779666"
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
