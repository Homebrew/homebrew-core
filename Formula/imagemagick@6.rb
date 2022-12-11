class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-69.tar.xz"
  sha256 "1aadede80cda9e3283b59a503c3e3f892f08d164bd9fca698e2d6aba9a88458e"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9da3b9f71c07174b3d336f155b6ef6fa9d2d131c9e1fafa30445780d23b735e3"
    sha256 arm64_monterey: "fd07fbf1ab916d1a282c8894c83c3fa8d5bfd8e1ebbcd6ca5658eecff72d9121"
    sha256 arm64_big_sur:  "34429ff1a23f4a9729ec9fccdbdce56ea226de1c630f7975231ed70cf781425c"
    sha256 ventura:        "eb22055393587871ee955d63a69d4548f28e44bfee6890589b2b46b5d11fe4e5"
    sha256 monterey:       "5d77b7d29997b4464faac0edd8d45744a1439055e95c24a8f0e337bf6600f2fb"
    sha256 big_sur:        "fa00efc3a426465b2185e599948d2d23f3b113b2374eb1c2a800b8f40088d9ee"
    sha256 x86_64_linux:   "0c37d712977c3ae4761aea6bdcddda4e814820fc9128364cf5f9ada8f53c7c43"
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
