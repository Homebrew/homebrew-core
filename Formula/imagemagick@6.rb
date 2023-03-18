class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-82.tar.xz"
  sha256 "effd296a160f584ef16277560d464f4183e6f700fe3b77c99d7e9a5335128ed0"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6a40a90bb69cc98784545314ef41bb2d79bd35054946ad40abec3ff34031092c"
    sha256 arm64_monterey: "cc96f4385c93aa4748e8927e567a28f4597c45e800b10d472b6cf2df3c5fdd72"
    sha256 arm64_big_sur:  "3d60466a24de352bf08025762027cb178ae2d735a2063842cdff8eebefa1c180"
    sha256 ventura:        "0fdf59688a7cde6a2ed7fb432afa12e203c6d58c8f7ca71e61667060906464e9"
    sha256 monterey:       "d4ac12cd0af79feae80c04c3e3b5e2f01eac4162a1d6be5ab7760785302e9ade"
    sha256 big_sur:        "81db29876dddfd47871cfb05a8bf72b4f99c92e60aa49ee53b39e95052a65549"
    sha256 x86_64_linux:   "a05899fd36b662d9df673a88b2e30ce315f2ba58c40ef0b44ebc87ba55e735dc"
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
