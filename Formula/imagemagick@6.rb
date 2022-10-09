class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-65.tar.xz"
  sha256 "172ee4b3a718e08edf416ddf2b0fd8bea60f47f257f6510ab933e5ffd6a1b0e5"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "53634e8b48ae68fd9ba1728b11b7b2229724750ec364de14b871428ba8caa7d7"
    sha256 arm64_big_sur:  "040aaa8b5b8b732cd4ba881b0d3358836138f4216b280832f35a3b079795d3de"
    sha256 monterey:       "d6b0fb0a7e325e8e3fbde6c3efc442a20e130bf15f9514bb50b2bfbc2c67df94"
    sha256 big_sur:        "ea119b1ffef997b6f745ba4901d08eaeee19012828dfa313bb8d98b894dc32f1"
    sha256 catalina:       "649ba2792ff39262a165857357390b1c283585a0a8bf50f7492e8ac163f59e91"
    sha256 x86_64_linux:   "783fd60937c826f2db8299aba6e2853d2d06e06cf1dec3f0d46aa38cffd8ef80"
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
