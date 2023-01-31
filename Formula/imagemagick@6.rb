class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-75.tar.xz"
  sha256 "45a3e4fcfe5432634a387bbf59b789cc234fcd93b5abdcb07ab09838d0589a52"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2ca4e9f37cb34997023288e4140ea8e726c158076a1c74bf5ed47ab6a1ee74a9"
    sha256 arm64_monterey: "c1d04a8945efcc23f98fb37bccb402358026a6a5fe35b06163286e5c170f9854"
    sha256 arm64_big_sur:  "ae0614a9aefff400e52340466b96f4db9c80daed3f6739bf45bd21fc32e48aa8"
    sha256 ventura:        "1213d048e9c413104178397cc121adfbc1c77152e3ceeabcbdf5042d09bae4d9"
    sha256 monterey:       "80fbaed39d0c41b5d6cb5221c9042267e5747684011c3e86f3a07c7032e396b5"
    sha256 big_sur:        "7d77a102ee9925599a03f982b6deca863df0d7cd4d8e9c48f0e1f2398a5343b3"
    sha256 x86_64_linux:   "279f6d88632c36afb04e088bcc4fe7dd58c42689db2e79eb398f2acd158a241e"
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
