class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-64.tar.xz"
  sha256 "57003a171b689e95de1a85f9201194715d7b6d2f2a6241a5efcbcd43f6768603"
  license "ImageMagick"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e4c4d6938a678115de6f39c9219500592263300335063294008ccdc4bdc7d3e5"
    sha256 arm64_big_sur:  "522a50c51c6313cd5e473ba6c4aeefcd92254f16545531859c16733b89aac740"
    sha256 monterey:       "7a0b564f82a41a95453e4e98c571f5ae368cd225d58822c36d6c064e2ae1071d"
    sha256 big_sur:        "81954428144fa195e1bdca73e0c03bc4689cb6eab7f6a19613f8b4801aefee26"
    sha256 catalina:       "b1af6abefb6cf799207895b3e51f49259786240f1a8e32c8572a9175e6ed6b75"
    sha256 x86_64_linux:   "1851832db2a84e1f0bbdf33d5d5bc6a3a058d4aadcdb3675b13aa5d7137de2e2"
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

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --enable-osx-universal-binary=no
      --prefix=#{prefix}
      --disable-dependency-tracking
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
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
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
