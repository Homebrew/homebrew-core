class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-81.tar.xz"
  sha256 "b7bd3d557d19fe04cc68d15c6d34c3150d9dd7eb762fc4997ac00b4aad690732"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a992c0920e497c981f51ef65c60e7cdf8b19687e2a4e538797f423e32048151e"
    sha256 arm64_monterey: "3772f23e5f2c6304eaf3436803418cdcb8927c87566dbde89b9353d262f7b3ff"
    sha256 arm64_big_sur:  "6d46f331540c396548d3142eecb918112fed56f055b343ebf0a5f30f6d167a0b"
    sha256 ventura:        "11781be53536f5c0b661488c0c6896c0fed1ad0cd7a3148f9b00283cf417f263"
    sha256 monterey:       "37b5f62ae1fa590a9ebae3fa0a3c19d3cc94d2891c4c244fe5aaed914b7f6f9e"
    sha256 big_sur:        "21a1d63097400235db38c7dff2d3c40b8cf6f9bab8a75b40efcf69fd61cbd9d0"
    sha256 x86_64_linux:   "82cb263dfdde13685cfc04f7fa1d93005a6d3b9eac186984954a144645ab871a"
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
