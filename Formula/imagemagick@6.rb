class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-44.tar.xz"
  sha256 "2fa4a31d239cb5e37c544469570bfa17f99af6fc7322765a4d8e992ec97d2d8d"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "07484bc32a347c8e7f30dc23b1741dd770337ed049fe7bbc7ee39c8f8a220af2"
    sha256 arm64_big_sur:  "85c464a260dd0f1ca31b4280c4dc4966bc8167d7cee90297f6c417e8261d7943"
    sha256 monterey:       "3b4d378df5b39d679d7c0c9d56a73e4d2602b10b52083a3955f911977e2ce3d8"
    sha256 big_sur:        "8a367cb547ed65bfea0aa29b43204afbcb8a0fa4897810622822fed9bdcdf8cd"
    sha256 catalina:       "e99d4ff1da7ea544b918587af45f046b0e0548b5e0c47000aa8728a2c64f4a2a"
    sha256 x86_64_linux:   "a72f483a04daa645d633e1744b10bdc6df8d7fbb3833adbb5675cfa3f50ba811"
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
