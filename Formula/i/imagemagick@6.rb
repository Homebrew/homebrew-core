class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-42.tar.xz"
  sha256 "6cecc8123b8ef066920d17eb8fe80a8c12e6ee7babb77834349a3697c8f0ac7c"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "90992b78e5858a7e20418ad9fb768e1ac60b6942b004335569c72c6c3a77f03c"
    sha256 arm64_sequoia: "1c02fd5b5f99faf822b3cedd767b1d7f2f0e235ad100a2470b4be115720f2586"
    sha256 arm64_sonoma:  "9952f235d774ccf6957935f982cf28a06e299ef4fdc840c23295c590245a80aa"
    sha256 sonoma:        "275750919a5f447074bd974812e79f3cf343a681f0daaed8e90470f4bd6cdcf2"
    sha256 arm64_linux:   "5e554ab837fd5c7ffd2785d3a454f6ad733271fc399a2919bb381f42cf6202a3"
    sha256 x86_64_linux:  "58d563a32172c37a7b07634c61ad5d0234591acbc12b38b465cbf308d8b47ce1"
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
