class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://github.com/ImageMagick/ImageMagick6/releases/download/6.9.13-50/ImageMagick-6.9.13-50.7z"
  sha256 "aa50ed87df37ee447a7eb3a526e0191ed443b33dc3e2f62cc0d875924f5852e4"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "532b61791f97d55b0676d3a947b3e39e9aeb0c659108142adffa37f1f57f8722"
    sha256 arm64_sequoia: "2d0ee23c473484e3910191567459d68426e6ca136d6df9ee4cd592e399d52c82"
    sha256 arm64_sonoma:  "72faf5220bd0599bb211eed8ee86f331d8f0345021b422c83e360a8dad3b26b3"
    sha256 sonoma:        "840d3a2405a94fb095bdb56b3c055c1ea61213c4958c5649e74b4f80605ce30d"
    sha256 arm64_linux:   "dbae808e55f23a83685a3ce59dbc14762540dcf5b69235f13902521a1e44ab02"
    sha256 x86_64_linux:  "53a0030f9ae4fcff282436ad7cf82e0e06109920405f1cf70d51f1ef7877749d"
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
