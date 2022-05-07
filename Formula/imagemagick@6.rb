class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-48.tar.xz"
  sha256 "8bf31cb269a8a26ad1cfd537ffabe55819ff719b7d269f1387a6164b93722323"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0fabce04d9bb8e1c5931de948f5c4113a5aed495bc1dbe1b23fdb30013f406de"
    sha256 arm64_big_sur:  "7f6e1ebe804ebb8fb8f64b31529c6dec01cccdba3450ca0d37add939c8663e4b"
    sha256 monterey:       "9b75e86f4f4c2ebb40da0a881bfb2b55ac7eb4aadd9c1e29f091be3938b73603"
    sha256 big_sur:        "78f1f392e48b686c6def8e6ea273d87e4f4543749769020d54cc15fd68a344e1"
    sha256 catalina:       "27dfd6e36a897415d79fa73802865abce694768d4cda8cf203d37c5b862dd057"
    sha256 x86_64_linux:   "f801edbf7ffd577c3cd1fdef1c4acdd774130852431aee1e1aa02addd7d1b2da"
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
