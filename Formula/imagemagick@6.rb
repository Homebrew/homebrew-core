class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-70.tar.xz"
  sha256 "d53afcabc763a2198d81ff20274adec39b5168733558c91081fc0ef7aa470ce7"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2dc3e2a35d06335ce712f300ff1d0e34e7a1c809c358f577b17d17c9154965d7"
    sha256 arm64_monterey: "1a3dc9fff2d2b205fa4a21c786c372c61b0172d8b9b6afb246c7310e42029c84"
    sha256 arm64_big_sur:  "b94d09ee9b3029a85cd2d043d36e70bccd67fe8cfcd84f224ec286916d4c8284"
    sha256 ventura:        "2fee786ba62ee608be8758e795962e4dbee12c6f3cefae316500823c73541821"
    sha256 monterey:       "a8533fef4aa404e0d435145f45e9dc990446bc0809806d0beb3665ac4dd65408"
    sha256 big_sur:        "afb08086fdc8864e11469900fa65ecf5496d0ec2e224aef7f4a76b5cf6694c41"
    sha256 x86_64_linux:   "98e47d1b5d51975099d107f0defa12584aa2a9d2f68a0107a8b9a87dbfe51bcb"
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
