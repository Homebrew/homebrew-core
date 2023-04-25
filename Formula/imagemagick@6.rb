class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-86.tar.xz"
  sha256 "5f3b9ef1bad7999d9aa6008f27f4190e6bed0c4f7f86c200b0a2bd8082aa724f"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a48e880820a9f64a94484c64bb9e52454a4b58611946a507a5061c4c795871b8"
    sha256 arm64_monterey: "1dd2d1491ee77ca6bca538ee98cbb2f8d27a89c191751d48f42da338bd2de71a"
    sha256 arm64_big_sur:  "9cbe62f7536a18f6562dec7d01e95c2a6b1b8e6665f15281e96935e3b496fcce"
    sha256 ventura:        "ceef183904861a93e187589d2ac81a3c4e889cd80d6c269a911d78d154137815"
    sha256 monterey:       "7d9ecadea31178d2cac09e45295ff3b453188803d69bce083a74069accd0681a"
    sha256 big_sur:        "145fb09110daf5f2e8b7ba124d8715054227a0c8e4212525a2777144f4f6a88f"
    sha256 x86_64_linux:   "f1a0822144e91cb279b1a3bf2dcc1de8dd9783872db23dd3ca307426d57e2215"
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
