class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-56/ImageMagick-6.9.13-56.7z"
  sha256 "bb879c2b4173ccac9db1e4e5d0965ba9eed12a9a2e149a2949d12319e979282c"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "9dfa1d643d0da7c0d1cb2e5da46c41dd6cef27a416b9050247e0f3f4c5e2d6df"
    sha256 arm64_sequoia: "fdb9810b70582c7156e5155ab7be6d4bc3e96328628bffe4eb69bbfe493f6331"
    sha256 arm64_sonoma:  "e31d2c0b77e0f2186fa0a456672ea4b4f45d023b6c064e79d901de1092daf1bf"
    sha256 arm64_linux:   "a8b0a7a70ea75ed5f79ec077aa09805f2214643e4ff8e6d22af1bd0ce9f38e5a"
    sha256 x86_64_linux:  "b21b7dc069897294690d21fb56d7e0fa0a7d4e6d1feb5880f947c827698ac52e"
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
