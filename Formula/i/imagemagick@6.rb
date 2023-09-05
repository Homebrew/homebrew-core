class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-93.tar.xz"
  sha256 "288f16a1aefce49aae4696d0dc3fb58a15750d9705191f6da56cd4aedc96e2f6"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "88228259b46cdfe7078fabc4ca44a9679042b96bdf6cebbd0ff1e5f37a8bd468"
    sha256 arm64_monterey: "e1725fc152c0c2f0c4da8bb081e1226beadd13ad03f59162eeb39e96aebacdba"
    sha256 arm64_big_sur:  "d00a76d18eb0637f33d250eb83d6c8b8432684d188fd91ce91e3e183959f0c0c"
    sha256 ventura:        "c601bed3cf98c5ce65f84fcacb33cc52f1a88a46142b7625c5aa6a854e329f63"
    sha256 monterey:       "be5127a3ce071d5e7c44d534e4201707d936bcbf97ef82439610cf0fc61b625f"
    sha256 big_sur:        "c9f15fa42a6261fd540ffd2fd80f599a2104cb7826c5b68658cd242b4a1dea26"
    sha256 x86_64_linux:   "af680bf6715cbfc03105452215e1ec6b1d02d287ea06c181628c846bdc61b776"
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
