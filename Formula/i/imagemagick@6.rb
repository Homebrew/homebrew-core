class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-25.tar.xz"
  sha256 "17ba5ee0e0ce4a2248db5115d3683dd7c24e82eec96515da028997c9f926a121"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "09cae28da4c71a6004c02518ffea95ef4df07fcc7f211eab10d6eac87eb48fb5"
    sha256 arm64_sonoma:  "3f7492a6a7040334c307e36e780a4e34a9148c2d644713c939ab8ccd4c82bf6e"
    sha256 arm64_ventura: "0736732b7c46c6fcbbf5106695758e428ef862d2a03414bd97c9986f0e1f96c7"
    sha256 sonoma:        "57a9fb490b1378cc28e1df03706e8d3c937c1d0aad8210c18880fc186069a6ec"
    sha256 ventura:       "68eeb42ec14914a27303bb7748bce2ced67135dd6824fba1a138f1967b67e8dd"
    sha256 arm64_linux:   "4d83ead3cbb27e2c7aff3f58e5796c07691a16c2574aede0ce4aa35f99bbc057"
    sha256 x86_64_linux:  "5487c6a697e5ec21472cadd645e053b289700c75c169a1ae9e0eaf52b482f090"
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
