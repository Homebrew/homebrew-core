class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-66.tar.xz"
  sha256 "4800ef109e60205919b320dc20112e1137aff0161c734a606bd1411dcc2f09b7"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "36814e26ebb60d2798b8477645b95113e7308612818acf938201e5ae1c4b96f5"
    sha256 arm64_big_sur:  "8327e5c12016e1773e20816c1bc436309cd716e11446f47c8eaefbc23820cc9f"
    sha256 monterey:       "26f8a25f2bb7a1a4655d88234823d35ca171f1dded4a8139e27d1d43b233cea6"
    sha256 big_sur:        "5d785176830f98ab386c35cb5eb7e0693ae5eeb22b5383990dbe4d9eac3dcb7d"
    sha256 catalina:       "8ad9cd9327b14cf15650bdf80dd1f035bdd32eff1a05d0f6047ebc8e3c9b2764"
    sha256 x86_64_linux:   "3284f2cc4a41dbf94886f005fc34c8fd74acb07a82d4546058fc729c5a17df35"
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
