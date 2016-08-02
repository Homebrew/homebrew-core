class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick-6.9.5-4.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.5-4.tar.xz"
  sha256 "00549fb8588673bb510e9dc952d9937b2cd1186e9322f5265dd96803e592eed8"
  revision 1
  head "http://git.imagemagick.org/repos/ImageMagick.git"

  bottle do
    sha256 "a3accdcbcda8013b5e37ffeefc0886423a8bb2c18ff1099455407a4387e7379e" => :el_capitan
    sha256 "3730960cf5ea75d1e7086205684f8f783242e2c69be369bb7c62a5b9875d75c2" => :yosemite
    sha256 "dab3137f07a50544b6a740ea5ed6e50cb8fbfa2736a4199e4acaf2d5661ea051" => :mavericks
  end

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-jp2", "Compile with Jpeg2000 support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "with-quantum-depth-8", "Compile with a quantum depth of 8 bit"
  option "with-quantum-depth-16", "Compile with a quantum depth of 16 bit"
  option "with-quantum-depth-32", "Compile with a quantum depth of 32 bit"
  option "without-opencl", "Disable OpenCL"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "enable-hdri" => "with-hdri"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "xz"

  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "liblqr" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "openexr" => :optional
  depends_on "homebrew/versions/openjpeg21" if build.with? "jp2"
  depends_on "pango" => :optional
  depends_on "webp" => :optional
  depends_on :perl => ["5.5", :optional]
  depends_on :x11 => :optional

  needs :openmp if build.with? "openmp"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    if build.without? "freetype"
      args << "--without-freetype"
    else
      args << "--with-freetype"
    end

    if build.without? "jpeg"
      args << "--without-jpeg"
    else
      args << "--with-jpeg"
    end

    if build.without? "libpng"
      args << "--disable-png"
    else
      args << "--enable-png"
    end

    if build.without? "libtiff"
      args << "--disable-tiff"
    else
      args << "--enable-tiff"
    end

    if build.without? "magick-plus-plus"
      args << "--disable-magick-plus-plus"
    else
      args << "--enable-magick-plus-plus"
    end

    if build.without? "modules"
      args << "--disable-modules"
    else
      args << "--enable-modules"
    end

    if build.without? "opencl"
      args << "--disable-opencl"
    else
      args << "--enable-opencl"
    end

    if build.without? "threads"
      args << "--without-threads"
    else
      args << "--with-threads"
    end

    if build.with? "fftw"
      args << "--with-fftw"
    else
      args << "--without-fftw"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig"
    else
      args << "--without-fontconfig"
    end

    if build.with? "ghostscript"
      args << "--with-gslib" << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
    else
      args << "--without-gslib"
    end

    if build.with? "hdri"
      args << "--enable-hdri"
    else
      args << "--disable-hdri"
    end

    if build.with? "jp2"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    if build.with? "liblqr"
      args << "--with-lqr"
    else
      args << "--without-lqr"
    end

    if build.with? "librsvg"
      args << "--with-rsvg"
    else
      args << "--without-rsvg"
    end

    if build.with? "libwmf"
      args << "--with-wmf"
    else
      args << "--without-wmf"
    end

    if build.with? "little-cms"
      args << "--with-lcms"
    else
      args << "--without-lcms"
    end

    if build.with? "openexr"
      args << "--with-openexr"
    else
      args << "--without-openexr"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "pango"
      args << "--with-pango"
    else
      args << "--without-pango"
    end

    if build.with? "perl"
      args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'"
    else
      args << "--without-perl"
    end

    if build.with? "webp"
      args << "--with-webp"
    else
      args << "--without-webp"
    end

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    if build.with? "zero-configuration"
      args << "--enable-zero-configuration"
    else
      args << "--disable-zero-configuration"
    end

    if build.with? "quantum-depth-32"
      quantum_depth = 32
    elsif build.with?("quantum-depth-16") || build.with?("perl")
      quantum_depth = 16
    elsif build.with? "quantum-depth-8"
      quantum_depth = 8
    end
    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
  end

  test do
    system bin/"identify", test_fixtures("test.png")
    # Test recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    assert_match "freetype", features
    assert_match "jpeg", features
    assert_match "png", features
    assert_match "tiff", features
    assert_match "Modules", features
    assert_match "OpenCL", features
  end
end
