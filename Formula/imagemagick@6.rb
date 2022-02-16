class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-40.tar.xz"
  sha256 "8f897e54905994311850224ea9dad1a2c92b829e735c7d21d7e7936e6d513af4"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "09625bf3e5c516240b2bfbeba8ca65942159bade43f3ac52b889d312f32d80ee"
    sha256 arm64_big_sur:  "c8def5fcb0a5a09a5796bc6a9b75663114426fa88437fd78c4e02def3902b89c"
    sha256 monterey:       "c6f6dbfef1005e271713273029fc9ee5f6dd26f7fc74aa6a550d60efb8a9c7a9"
    sha256 big_sur:        "319a3e43f5abc407cc37e0292e7d76915e285155721637dd79eadecbb74fc399"
    sha256 catalina:       "06cd5245e85c4879be15962b1845da504953e31ec421201acb717552a098b896"
    sha256 x86_64_linux:   "8761519282deac1fbb2314de0f6555c199edcaf2179209ad574dc919dba3987f"
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
