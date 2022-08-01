class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-60.tar.xz"
  sha256 "9b23870a2d6116be045b6788c5d88ec66690a3a839ce23b8dd89d547bb3a5b31"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "00f948de536d2f62598fd4b8dcde5e51e705fb6dde74f1103100c763d60cc7b3"
    sha256 arm64_big_sur:  "fc8b1ec6870676e65d26f543ff589fbf1cbc1dbcef365c3e22c95e6c58a39bc0"
    sha256 monterey:       "f610e55e4520107cccf53ebf5115ef2bbe1ba11a78380b19d843a44e346638e0"
    sha256 big_sur:        "d62232418d0f3af2836b66e69bb63e220e9ae2e9c7d67c588abc324c4d40a393"
    sha256 catalina:       "810768e80474ed0f96145aab3f7b0b7cc0e6f8a7736d7f168c38d9635b506756"
    sha256 x86_64_linux:   "ab0a006d84f7c82982d836e2c051bf7088b7f66707655fc9517698d529d07fa7"
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
