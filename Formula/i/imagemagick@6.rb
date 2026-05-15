class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-47/ImageMagick-6.9.13-47.7z"
  sha256 "de5d065d86ef962d113a8251d609d59e16479375c49c79143cb456526d32d699"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a9b0ad7c71b87a527c39d16b6c42036dc831e913ba38f5efd9f812197134e48d"
    sha256 arm64_sequoia: "e4b73242a83a344638ae38838bc1b65177d40776666b2797f8a65b3a6df36b79"
    sha256 arm64_sonoma:  "72a9fa7db21ae183e2e608bdd6961ee3ab7133199945576230cfeeff9e35a20b"
    sha256 sonoma:        "772697855d127f5851d8a8e124c10f54227e39f55fd4e2e0faf98977a92fd013"
    sha256 arm64_linux:   "c3459f212276d8317a1a55652bbf7fb56bdce41ff476c8637c03fdb4fe83af78"
    sha256 x86_64_linux:  "290f76bcc7df07d7a374afaa4d881a9cd36e1eaa03f094cbb3a6c50ece37f153"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
