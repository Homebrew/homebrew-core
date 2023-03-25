class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-82.tar.xz"
  sha256 "effd296a160f584ef16277560d464f4183e6f700fe3b77c99d7e9a5335128ed0"
  license "ImageMagick"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "998d559ceec8157eb18450717b01eab14f760561ea1caa3be15fd34979f92514"
    sha256 arm64_monterey: "df9fdc7f0001cccdfc7e7934964ad36e3f3d5257ad46c798bb572d2b28ba4fde"
    sha256 arm64_big_sur:  "c2f00c6b492c7364fe751360d5586f67828792bd9ef494677129d2a2fea1be3a"
    sha256 ventura:        "4bf46306a05c016835e0e53b3d7766d28be59b7e3565fd7c398a144cba1707ca"
    sha256 monterey:       "69eb462999e89ef2a7fac3f7c43da453a676e4d686dc5790978386a5fc96b0d3"
    sha256 big_sur:        "79e8f22971beaee499b46b8d3aef4b25c14696f12e1f4bfa549b264c13b58bbd"
    sha256 x86_64_linux:   "ecade09603480b5beb15843a0450347cea0a28d2d71142e75a7c82b215bc477e"
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
