class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-26.tar.xz"
  sha256 "c286a233340a98d5ca4e86054d1da45f6b4abf5523f92e2402b86f7d8ef51bb1"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "dc8a199d5c422ab06d07c9fcc16d2e689147f719cb4e5a5434e89678894e6d01"
    sha256 arm64_sonoma:  "d9dd876e73df86740021e5e5552db6c30e36f1e18da5cadf73eb50249230131c"
    sha256 arm64_ventura: "1d85bbbf812a7506472a4b61d276952b54e570fac8b61a9983519b4d6dc3109b"
    sha256 sonoma:        "182a4f4ede08575ed478d7e268fa76ef326f16782d0d6574c12508bfed273d75"
    sha256 ventura:       "3eb22aa9d0f0fb1c5f43499ea234a9918dce7252723534191670f09fb58dd6d7"
    sha256 arm64_linux:   "558a1e2980a8b4540524e0aea5acc9cbf0350ff104953f65b5f222be456d2c81"
    sha256 x86_64_linux:  "831be837d42081b5339fe1ee04620de870faf54519fd021430794d45a48fbfe6"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-djvu
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Ghostscript is not installed by default as a dependency.
      If you need PS or PDF support, ImageMagick will still use the ghostscript formula if installed directly.
    EOS
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
