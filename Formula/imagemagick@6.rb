class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-74.tar.xz"
  sha256 "cdb06a20d635d6c0ffadc0f07253d089c4e7ca3a012332b8c04a944a38aebe11"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e0f5c283e1cc5fd5b630d7f76c42b9d375af23620ec833e4abe49bfc4641a814"
    sha256 arm64_monterey: "17253c4508584be600923937d1d62fb2f7a8313038554f9ac8d905e5d81cff00"
    sha256 arm64_big_sur:  "752edd633e4cd4978a0e03789c3ae038eda1eb207a0235c1b7b7248f0f94cc15"
    sha256 ventura:        "51b785dc5d3fd99ad62a5b4f466162ddefcf4171ffc485ccd99bee9cc52d1ff3"
    sha256 monterey:       "904706dab4af211bf7f352aa0b5e71af633c84853711e0f88d03db392bea0a9b"
    sha256 big_sur:        "7f4fdd76125a0798f2c5dac469489ce2aa6094f823e3e78c9132fb9723318091"
    sha256 x86_64_linux:   "e5afdac1ac7ae9b2af7027aa0168f80503b0dc8a2031a021968252705f0cd7ff"
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
