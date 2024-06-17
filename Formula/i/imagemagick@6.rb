class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-11.tar.xz"
  sha256 "aca9e58cbb1a591114ac1818d928d45bd2ae0c95524aaa92042806a0f6287591"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f786672897396b4c50f1114739dd291b7259c70c322bf214970134c133df937c"
    sha256 arm64_ventura:  "43d9c0e742f35f26745a44fce891815ee8ab0499cc03ec05403677ca75486717"
    sha256 arm64_monterey: "40487a3e9404a416068fa8035228d8878fe2535222bd1994e8d54d4cd02a21d0"
    sha256 sonoma:         "3e85fe9ea316601fe968580a778092b0f3a8cb96959b7bbd9f129d0cef58e275"
    sha256 ventura:        "21904b3e7b26b3dd2b41a628404c86dc36e438b42b9ed572a68c77c58be5003d"
    sha256 monterey:       "492476c5a7ad7b4c3681c0c379e33d0d3b011ddb6e06c59d005085b5847bd3d1"
    sha256 x86_64_linux:   "d98126861efe6a11435aac895dbdcd3edb4a36b1df8ab8df1ae8f45632de03bb"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "fontconfig"
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
