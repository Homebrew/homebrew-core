class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in select formats"
  homepage "https://imagemagick.org/index.php"
  url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-21/ImageMagick-7.1.2-21.7z"
  sha256 "c088acd4c3e7f1a98e10512d70282aedeadf666f19291eb07f763cd6675e404a"
  license "ImageMagick"
  compatibility_version 1
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "54371751db99ac5fd1f11ed1ea56616b8aa00e589e04d9ee0332741287c016d4"
    sha256 arm64_sequoia: "e1bf98fa07bbec7829c10aa9a45eb88f9a4f191563e2e53fcb14f40f5d879847"
    sha256 arm64_sonoma:  "051a00bf46e408492b3bfee2a99e038e397e7325a81297929918ed7a0c883d81"
    sha256 sonoma:        "28063c63d74ec1f3e2c57d1ee17c0fd49d2a7801dd57a6097d3d278993e7ca8b"
    sha256 arm64_linux:   "6e9735c44eb103a67a08d15e4b0be6788554af42b0d909eed71bb665438564be"
    sha256 x86_64_linux:  "667b1b9fdba8362ea847cf3259937ecdce96cd59846cf4da3f6f2f4d54ee0040"
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
