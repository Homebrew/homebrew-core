class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-9.tar.xz"
  sha256 "bc9de3b22fed35d63cf54cf389b49b524eade39462f72a15afa5e272ea606607"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5343b66b23c64ba926e8b91d2005ee0149f49b26eb142211a9b8c58bddd4541c"
    sha256 arm64_ventura:  "373bcfd6ad92a3e513d3ed268acaa8042e60c53493515734dfe60b4b626f17e2"
    sha256 arm64_monterey: "c89a5884dee0a556b5ffc2193712a9d458986896353398cce7756fe4a63644a9"
    sha256 sonoma:         "c2dfb942610976df80d8d06a30d3cb4c462061428c70280b4f5d8febd9f1cc23"
    sha256 ventura:        "a79c73472b1bf051bfcd992f0176541e3d6874991b1cd6e27c9f511d73eae30f"
    sha256 monterey:       "555a706a2d1880600015f67214fc56aa76b5e78a355f8298cba0670e62bd149e"
    sha256 x86_64_linux:   "9816a46f573abe9eec97feb484478b2d6688bd737802b1095aba7fbf038b98e3"
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
