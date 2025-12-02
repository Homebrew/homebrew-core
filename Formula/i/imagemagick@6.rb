class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.13-34.tar.xz"
  sha256 "e53da416970929408e7e48186c6dd205f70d0126bfaead18ded400b52d1a4663"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "44f59e312ed4d7ab305dea1a2601fe66870438b4a467becbdaa7195f404f28df"
    sha256 arm64_sequoia: "e9a6bb8bfb54f8447c7f3b93635674828762027ebe2c739e9395d69224ae7d1c"
    sha256 arm64_sonoma:  "d05917f7c9fd1c09518d35d7ea81cc92d23d6505c92cb6dca2a37e8d16c22248"
    sha256 sonoma:        "c502abc338d9f03058fc37e0011416e84b8b8efbf0e0cb82dda49f4e056cd70f"
    sha256 arm64_linux:   "86d3224f44fa9a152f7e741718283ae833bbb49824e2c80d0970b110c8e2fbd3"
    sha256 x86_64_linux:  "425928812de44a19ececb14f6e1867c24213257abd30ab4c41d68e2328151e19"
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
