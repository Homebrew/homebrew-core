class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406-6.9.11-56.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-6.9.11-56.tar.xz"
  sha256 "882c785058378bcadfc14310abebbc7f6a704203a459fb7aeaad22282507adf4"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://www.imagemagick.org/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 "36f96bf89066836288afe31d316d5bfd2b96cc334e95e29faef01e3fed7013a1" => :big_sur
    sha256 "d7fc8e339020e4815bf2c3e6d48d6d2c9a58e7290810b7a32e9ec7a5feb76b22" => :arm64_big_sur
    sha256 "fbf123dd10dc8a30d887f89ab29a32c33d69d2bd1f6282f45105be6dfc04d4cf" => :catalina
    sha256 "f5e5aa748ab267541c15eccef09222d68bf6a13543af1fd698e322466acae894" => :mojave
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
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
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
