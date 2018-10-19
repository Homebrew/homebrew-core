class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick--7.0.8-12.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.8-12.tar.xz"
  sha256 "48df5877fe85603940310fe5c811a89af416882b60379918a95dcd4de6582b55"
  revision 1
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "05fe4c90f1b079a2abdd7332083d23240d23f5ff9dbceef25cdec1ac7432ad6c" => :mojave
    sha256 "1600d96a0a2a836c989575984250b6af081744c295a685c842c4027ffe88518d" => :high_sierra
    sha256 "5ab7691f2f45d62bc569051f54001de7379b71d94e45761b0b441fff67963b71" => :sierra
  end

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-libheif", "Compile with HEIF support"
  option "with-perl", "Compile with PerlMagick"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-libde265" => "with-libheif"

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "libheif" => :optional
  depends_on "liblqr" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "openexr" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional
  depends_on :x11 => :optional

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-webp=yes
    ]

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
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
