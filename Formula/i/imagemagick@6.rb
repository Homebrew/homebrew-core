class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-14.tar.xz"
  sha256 "2ca9cbb27f2c47e2c4e20e4c6b299ff692077ed1e5e01104fcf72176fd6e2254"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "57a13d81dd7832322313ef3997a879dec356e5dc4f1b598652693a0cc9ff818e"
    sha256 arm64_ventura:  "7df0eee0188a9958daa9c32345562b40caa5de8130700a60bf7af7bb51f1c7e6"
    sha256 arm64_monterey: "dc5ae2222c6b9d821c30a162e711d3f334543f8ba2506e0addf8b13205bbbf05"
    sha256 sonoma:         "c68dc87c62d4a1209640ce5d225342beaf9c459ae26b6a8d6f4ec66ee780e058"
    sha256 ventura:        "cac1ae68a7a0b9f208c594d534d1a29e33b8a7420e6c62ec9f3ecf9113bd96c5"
    sha256 monterey:       "d7a06088e5af59475e4d8a7c82ca737b878bdeabc3dcac9cf1a5f4a87bcd0399"
    sha256 x86_64_linux:   "4c95d55fce8038f0287c1b03c27157b5c7121362ec5e06ad42b85faf302e4f5c"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
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
