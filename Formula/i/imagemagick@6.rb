class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-8.tar.xz"
  sha256 "4af82b0379c24c1efb1f0f6b41fb4646449db79a5d626f904e0a39891a3590fd"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "248f7fe91776c72a4264b304924b75f49fbb6de71a2100cdfa38f91fd605f542"
    sha256 arm64_ventura:  "60b88d74798768a5de5043ee43e9165875b2110814a73c5629ce08c22dff622f"
    sha256 arm64_monterey: "a355b4d69a730ac1593791346f27279dcbba22d2cb6b4dcd5893935351448a76"
    sha256 sonoma:         "44b9a513fd8490db3f4a219e372cae9e31b5dce34d36bc590ba0e21e91dbbbc3"
    sha256 ventura:        "91e767ce6821227087d3cb4c66df1b93b1bda46493baf77109761f1bb0f1bbe8"
    sha256 monterey:       "d2cc8d2bed89c8ff532d326dbc27fda76313ae0ca6dd142ffd537844795bfcd9"
    sha256 x86_64_linux:   "7562dc256360d7e15136eb312e4a3127469a54086175080c6786e516bfeb6a83"
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
