class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-85.tar.xz"
  sha256 "736cadaf65328b07c3d7d0bf11078bbd99fd538a3d348990091a7edcf6b0c958"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "515729fdc43f93f3946f1f51995a8711fe77688502ca5731dc74c466dcf0f925"
    sha256 arm64_monterey: "49e93cfa4142b0c9a08adaf33f60aa19ec67bea41e439ac4fbe9582e6a260bef"
    sha256 arm64_big_sur:  "32b4d76c60dc9e18ea363609371d8dd884d7e10139441e6051d04b265f3d6198"
    sha256 ventura:        "a7b7ac2046af148b15e5d094698a942d47aa170c6fa65066fe171d7596b7b871"
    sha256 monterey:       "94efbeffee7d9d3e6b6ef4c5be340837fd1eaa8b1376993c9f50a2cefd8fa1a1"
    sha256 big_sur:        "cf4048749cd850d636bd236f2fa32cc0c2cf0e075747393f3ab49a91fb5edbca"
    sha256 x86_64_linux:   "3680468c077f4389e552778fad1ec7e895cd15de3c6d165f5b0f5afeed1cbde5"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "libxml2"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"

    args = %W[
      --enable-osx-universal-binary=no
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
