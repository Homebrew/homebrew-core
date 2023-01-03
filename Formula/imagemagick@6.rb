class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-72.tar.xz"
  sha256 "4af01f811426ac2aac28e0035cb49c964a1c47e5aee6c23379e7bc9f3b51d6f6"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6b17f3851974c51e525efa5f6ef471a360d3e92a4d4e93057b3ea0bc0714f51f"
    sha256 arm64_monterey: "7bbc0db45705f682a2e49efd39e4153c800e2df03d4d9c58d9d011ac910ae3e5"
    sha256 arm64_big_sur:  "7dbe0c32f30fe605a634e71ecc28ae863dcad1eca1aae5d1cc385e155eee94c4"
    sha256 ventura:        "47f643f0fb256a1274be8d337b8dd3978860f378fc215b5c8deb9b4e0cc636f9"
    sha256 monterey:       "e5871848ae1081376b31bc918f149b9ec1a98811bfc25bca103f9102b8b5fe7a"
    sha256 big_sur:        "fc8eb3a91c093cf5da1156a8094076c260d5739965704d1c5f6f87b02aefc822"
    sha256 x86_64_linux:   "3d4fdb733428f1cb8d8d1876b0b0dbb259da4d3b99a5c1568eeae264a0f257d1"
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
