class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-29.tar.xz"
  sha256 "fd057bf7e3079b55cc60a64edf3c98a2bf01d3887d6339eef91c1ad1e74dfa44"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d1cd2bffa46b0026a643384a9d3f8ff394aff62c0c39ce99c994eef539e51e82"
    sha256 arm64_sequoia: "24e06553551081cdb72225fd051ff33c4947727e9ebcbcdb8860eb9e0bbdd047"
    sha256 arm64_sonoma:  "49b1f6f3edad2646fa5a41f03556bddf97961a0f779f6fa45c7b12f9a977f490"
    sha256 arm64_ventura: "08c372c4cf26fca513a8e370f89d6b65d9a4427ee3d7e0f6382a3fe94a70cc1f"
    sha256 sonoma:        "f9ea0a3650891f10a0f9b06158bd3d860bb0930f0ba6f6aafbaf72a7c5f8845e"
    sha256 ventura:       "66969625fdb79969f0e0e55a67b4f65ce4828f87c812ad411a22872db8a9b5c7"
    sha256 arm64_linux:   "a42701d70b3fb6435113abe80ee0fcea61560951829e7e9e196a80d6e46de21c"
    sha256 x86_64_linux:  "e9312b60d916081414130ea4c855f40e9da7ca7cd5b9a37ab81b9716ca5faf57"
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
