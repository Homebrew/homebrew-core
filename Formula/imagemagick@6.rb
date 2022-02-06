class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-38.tar.xz"
  sha256 "86d4a8a857f24072ddf488d58ebdec7536c6ea9a95fcb5e0f8c31c93ef0feb0d"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cb7d1a2a64f72130b6926b9d802a471a46fe6cf93aef7693f57a9d20bc260612"
    sha256 arm64_big_sur:  "520ef31feb2f562c01d0d217c91a20713c2df07208bf54044bc915bb62af713a"
    sha256 monterey:       "1ce7a0624780079eabab4fb636d0cf64ee736256cbe4ca6d690c65ecad400fd2"
    sha256 big_sur:        "77d64ea14b1b6886686f7ca386b6da546fcbf60105453259e6e45d9da1cd68dd"
    sha256 catalina:       "75e889da8e2e36321b28a5f0ce0569b91be05fe1a0173c625eda93ca5525d968"
    sha256 x86_64_linux:   "7e232771e7538595b225756f7662cdf09036d188a875d3a28e43ad8278bb8768"
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
