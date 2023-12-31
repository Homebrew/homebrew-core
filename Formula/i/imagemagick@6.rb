class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-3.tar.xz"
  sha256 "734d55e4e54495eae707d41d36982d11c47183072592d5bae29f62014ed61c44"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0b9de983e8eb427185f17d0eb8ea34558f9d212f601b7149e16b281db1becd31"
    sha256 arm64_ventura:  "56c96f65ef286deeb12b9634192e26b6002e1f42e1cfa95c267986baaa383a67"
    sha256 arm64_monterey: "3fe79aaefd12070d648571183f39f08281f87512cef4ca6e2636c6a0e4f98e79"
    sha256 sonoma:         "6c75f7979d2404f3c680ab9919df0ff19d97e8d9bfb5e0feda58d4da8efcff8b"
    sha256 ventura:        "5637afa2a898d10c5388d9023770ee9c653906497f3c7ac0a94a272c78252ab1"
    sha256 monterey:       "da09321ea161d1b404fb29e373c63b49f9c2b4b0e1c0a134aae47876ddfdf6c3"
    sha256 x86_64_linux:   "f0d16896261beebdadc216a41e28d00fe179f2fdd987d6b43c202ed882044080"
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
