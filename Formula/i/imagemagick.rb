class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-25/ImageMagick-7.1.2-25.7z"
  sha256 "a83f48a58e9d5f0fd7a6712bdc1ee76281c8f429d1dbc9b05b47719eaabb1dfb"
  license "ImageMagick"
  compatibility_version 1
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "4bf60da9f162896e27798f7e95036f5675dee9af2b404f8b82b43cc8202e571a"
    sha256 arm64_sequoia: "440c3c25de2111cfea357c7b01571cbd2e6d8eee2550a08e3f550e5dd37e0d32"
    sha256 arm64_sonoma:  "e258997a8c6266aef133eff6cd887633f95e393a1c41daef81c383da9fae6cbd"
    sha256 sonoma:        "249a896708b5a45b736a2a09cb82339cf25313ee77e3600817c15f0d83610665"
    sha256 arm64_linux:   "7f4fc242ad4742203cb4e93eec19acc8229e67bd37d6d1c21bd22b212b9ccde1"
    sha256 x86_64_linux:  "bf7b73727561884518679549ffb7d10999abbce9ba766be652d1211942ed15ca"
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
