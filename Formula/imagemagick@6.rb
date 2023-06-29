class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-90.tar.xz"
  sha256 "6d77931bbf3d09c4d93d019208ea4cc525160dd3dada17476137592c0b7a586d"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2c603d5a9f3ca774c900ff9c9578243399df389069fded1ce386f07b6101af36"
    sha256 arm64_monterey: "dca10bc8ffd83a915c2fc946f069d9012a377db25f8de795f3fbc611562c4611"
    sha256 arm64_big_sur:  "640f09d6fe9a60f771e6dde9022b1deaa90aafd17da1eccb97867edae6860161"
    sha256 ventura:        "1cb548da7cfc9745da53a8572856665531e2d39e1828a0592829a4966e906e76"
    sha256 monterey:       "4f1c8691cec6af9932a5f00ef8096601f83ef9f55ae500e307fb03c56910d3b4"
    sha256 big_sur:        "9d8fa6808bf5562cc0802393ccf72954ee8ef911d76056da3a4c76b5e5ba3d2a"
    sha256 x86_64_linux:   "2d0f20a699b42b9bfb6ad8ffb797bdeeb6f2c5cff708003a940116c6c2b262f2"
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
