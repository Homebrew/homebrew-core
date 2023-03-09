class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-78.tar.xz"
  sha256 "844886e32f2063b3063b4cdab3fb8501eff6c3f286a929606f7759fc3630fef3"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4a8bca64b1cd8775846e7716683ceda618a79111332d843d5da297186d5d9653"
    sha256 arm64_monterey: "9a5dab6b00b9d6938e2324131ab048a6be6c782591a0402e7c61a0dc3fcf1425"
    sha256 arm64_big_sur:  "9a293e55c171cae8700853974c774f7ea08e1e09bf626ded09d22368b169c43e"
    sha256 ventura:        "f007fa7395a8892d0eb3f8bcba28cd09e41f3229275749afe9d580ae124cbb2c"
    sha256 monterey:       "4c0558a141bb9422751e5c21ef60d8d82b79a77dd6c8cc041141a4be4f0b85d4"
    sha256 big_sur:        "54d26713322b5a423b33baf9302b9923bc2cd0639b9f19a17bfcf65bd92c2aa0"
    sha256 x86_64_linux:   "8513a9c8b8bc38939d3c2cfd24d90ce3c312c50b9ac1fd22478cb54cb54932ef"
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
