class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-11.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-11.tar.xz"
  sha256 "2d1c61999a9b1f663a085d6657cc4db4b1652af6462256d1aa3c467df3e9e6eb"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "0254e5b8c4b6b89f9e4303226656ee96a68d9590934f755db9d6205651c4d27c" => :mojave
    sha256 "7baf94f2c7d0662ee80aae378253a66e573e52097accdd9f6ea1509c2c088798" => :high_sierra
    sha256 "3e49a20a7994f3e76babc965b292292be067c4d2153c5a68a5971b0285ae72cc" => :sierra
    sha256 "c19a1cf44470f4d41fffc2346df4156903a65683632a086efd958112c6846712" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-opencl", "Compile with OpenCL support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-gcc" => "with-openmp"
  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "xz"

  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended

  depends_on "fontconfig" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "libwmf" => :optional
  depends_on "librsvg" => :optional
  depends_on "liblqr" => :optional
  depends_on "openexr" => :optional
  depends_on "ghostscript" => :optional
  depends_on "webp" => :optional
  depends_on "openjpeg" => :optional
  depends_on "fftw" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional

  if build.with? "openmp"
    depends_on "gcc"
    fails_with :clang
  end

  skip_clean :la

  # This isn't an upstream issue and this patch should not be removed.
  # Imagemagick delegate configuring secure defaults to users/packagers
  # and ship the most "open" (and thus potentially unsafe) configuration
  # possible out of the box. This policy is inspired by both Debian's and
  # the advice on Imagemagick's related page:
  # https://www.imagemagick.org/script/security-policy.php
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a95f9dd/imagemagick/imagemagick_safer_defaults.diff"
    sha256 "3f22b13e206d2403b53692412b7b69d175530f5977350486b81da5027c548b44"
  end

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    if build.without? "modules"
      args << "--without-modules"
    else
      args << "--with-modules"
    end

    if build.with? "opencl"
      args << "--enable-opencl"
    else
      args << "--disable-opencl"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "webp"
      args << "--with-webp=yes"
    else
      args << "--without-webp"
    end

    if build.with? "openjpeg"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    if build.with? "ghostscript"
      inreplace "config/policy.xml",
                /.*EPS,PS2,PS3,PS,PDF,XPS.*$/,
                "  <!-- \\0 -->"
    else
      args << "--without-gslib"
    end

    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--without-threads" if build.without? "threads"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--with-freetype=yes" if build.with? "freetype"
    args << "--enable-zero-configuration" if build.with? "zero-configuration"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
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

    # Check our security policy is working as expected.
    cp test_fixtures("test.pdf"), testpath
    output = shell_output("#{bin}/convert test.pdf test.jpg 2>&1", 1)
    assert_match "not authorized", output
    refute_predicate testpath/"test.jpg", :exist?,
      "Imagemagick's security policy was not enforced as expected"
  end
end
