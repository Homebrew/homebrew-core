class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-25.tar.xz"
  sha256 "e0c9956a4390c81c442152e446ac28c9f9808cf9f35241cd7a5f8be6381d0c8d"
  license "ImageMagick"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "37b56abc50f1103cb63c6f8e21102bd58129eb653fa815cbb4ccae0ff1321aff"
    sha256 big_sur:       "8e8dcb35924d9dab94bd4b6581ca843acf54ee3b335b0a58f0384b5f3dd149d8"
    sha256 catalina:      "9d58907a9fb856b936eccb6a54a27f97b348fe05f77516f58331e7d1c0ae3dfa"
    sha256 mojave:        "b39a9eb965159a92957d04fe1d50f269f576540f3027d4a4566e119b5e50ba08"
    sha256 x86_64_linux:  "d403ede8fe65392361e1ab576ca1b9e7befdfd7cc74f00febcdaf94ebcc81add"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
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
