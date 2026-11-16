class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-61/ImageMagick-6.9.13-61.7z"
  sha256 "730ad78658a2f443b2384f4f0b4e741ee98ba7858f3e6db8963e1c8090571015"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "23fd7771791377a46e929c38a4eb58ed61720df9c92f4a224bea892960882ef1"
    sha256 arm64_tahoe:       "cdc3da648c30ed9eaef84e414611c8642b29499beca25dc751e7afec3bdd2685"
    sha256 arm64_sequoia:     "9777cb044e0ffeb7dd1727800e78af9ff33b487a764e20e4fd556268cb8eea3a"
    sha256 arm64_linux:       "07359cb492a67c6a9a0f7998b60368cd69b4df8c4f285eb08b4977774a39f845"
    sha256 x86_64_linux:      "b005ced8ecf771ef60cba480a2686a12a6bdaf0b1404e45ea208d32b9bffd634"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-05-01", because: "is end of life and only receives security updates"
  disable! date: "2029-04-01", because: :repo_archived, replacement_formula: "imagemagick"

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
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", formula_opt_bin("pkg-config")/"pkg-config"
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
