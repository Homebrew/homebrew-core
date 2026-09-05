class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-31/ImageMagick-7.1.2-31.7z"
  sha256 "a050a1f6b632cf3a5b326fe6fb863790ce4d52d55fba9c6a7645b42599660e18"
  license "ImageMagick"
  compatibility_version 3
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "f72504a4f06aa03a45d787ea6fb43d14d31833b85d128b317a9a9b6ec0da62c9"
    sha256 arm64_sequoia: "035185eb153f354021cf8aa54022ec42a2064f07c0de5118424066a8eed98755"
    sha256 arm64_sonoma:  "39624884b98c527f93677951289db3759cb902a8d73f69552a73fb65903a7bca"
    sha256 arm64_linux:   "5949df67af1593e6d2b82ca721d1029174707f4f9aa8d47d436882a4dd06afa9"
    sha256 x86_64_linux:  "c26e8a7a710f22a741474f32c3f8b034adf53d18fc15e372d2addce4469302df"
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

  deny_network_access!

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
