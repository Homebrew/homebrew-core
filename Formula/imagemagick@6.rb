class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-26.tar.xz"
  sha256 "e0a7661f921ce73a5fced9b4e607a7a75c95b22b78f4eae4dd3ea59f0f413bc5"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "10a3ae3d68c180bab07b6f4996e7734cecd01dfd7a1f14ba8488f8ed27d8bf2e"
    sha256 arm64_big_sur:  "25f94d79b3c99f93fcaf233d7b1bfe429146019afbeb2038bc6f7f4730bed88d"
    sha256 monterey:       "88bbbecc43022ebdd2834a29f74eef2ab42e6ff67f38b6783e849b8e4d812831"
    sha256 big_sur:        "d5e4a061665d42a839a392bc1cb7af0e1c563ed9c56e2a17509211962c7d5b97"
    sha256 catalina:       "78c23c4ee9c43c18f7158658665bf71bb42b8d5476dd6377a957cd9fef5c3e07"
    sha256 x86_64_linux:   "6cd290ceab684f2d54533e07ae5423980bb73a10a76a95f9079e8f30e0951732"
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
