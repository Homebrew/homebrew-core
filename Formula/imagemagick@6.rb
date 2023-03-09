class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-80.tar.xz"
  sha256 "0158943e02bcd1fa552b03815612030a340c62da5fd30fccecff90b6ca565aaf"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c8f0fd0d1df9ba020a5051a1c170650aa896dff0d78b16351814e70c79871b73"
    sha256 arm64_monterey: "3ae4e2776c78b787baa869dc093d9da88c006b9d5f189b929107da253b3ff368"
    sha256 arm64_big_sur:  "84fa767744199547a5fee1579dd9adef2802b96298613437470d61bc43b15977"
    sha256 ventura:        "ec6d5a190fc757e5905e6ea65f5e31b91e2cd1357c79fa0736dba2830b5d5fdb"
    sha256 monterey:       "cf2620c7faa4f74b3568cccf914e9125c23e482db99045241b35af8c81ac5ea5"
    sha256 big_sur:        "be4f78cd66813ae4ed08a1e88fed30fed426eb8fd78a6a7502856d609192d44d"
    sha256 x86_64_linux:   "5e47ca3ecd34ed612aea37e5adf9f43ac2af489c02ec54346d9139959fe335bd"
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
