class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-75.tar.xz"
  sha256 "45a3e4fcfe5432634a387bbf59b789cc234fcd93b5abdcb07ab09838d0589a52"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a07bb18c5cfb163a13a04936e7fb05fe3ad4185864e988f747c2898144f7bcd1"
    sha256 arm64_monterey: "3d844e3f492c6f5e07bf423d1fdbdda1bd63a122f74302a2bd4d446b0c322b11"
    sha256 arm64_big_sur:  "45ca2f6c2c5adf24db2db37f176145e621089b4461d5fb3f1c919c596a952291"
    sha256 ventura:        "891d32a6ee5fb64bc617e4be953925f472e6ff0874de04a15e0e4a8c571069e8"
    sha256 monterey:       "5af287f11b0a5b6ab81494b3e303a88f67df057125380f25bc6718d969a4417a"
    sha256 big_sur:        "1fc03a5471776f9c2a916e0503bc03b1a3a6dc7531fab29e26c7b23c5adc814c"
    sha256 x86_64_linux:   "d0df29967422c4221fdc347672d6774c3570128b21ff3e136aaf5500faa7b59a"
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
