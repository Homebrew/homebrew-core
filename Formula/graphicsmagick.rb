class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.25/GraphicsMagick-1.3.25.tar.xz"
  sha256 "d64bfa52d2e0730eff9ce3ed51d4fc78dbb68e2adaa317b2bb3c56e6ee61ac9f"

  head "http://hg.code.sf.net/p/graphicsmagick/code", :using => :hg

  bottle do
    sha256 "aadcff3e84a492354073cb59d107b6371c01c0863ce947d03b48a5960914286b" => :sierra
    sha256 "e0e72ba85c6cc4d5acb13d093f2b3c59f02f0d81414bb797775d161e17ae2ed1" => :el_capitan
    sha256 "36c0f4a292253bfeb4184b8b8033c98a767891fd97d3cd53060a8be3432f71bb" => :yosemite
    sha256 "6846286eb57e624fab71cc5d5b1066c16636dae781d821caf55c9f181f73c425" => :mavericks
  end

  option "with-quantum-depth-8", "Compile with a quantum depth of 8 bit"
  option "with-quantum-depth-16", "Compile with a quantum depth of 16 bit (default)"
  option "with-quantum-depth-32", "Compile with a quantum depth of 32 bit"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-svg", "Compile without svg support"
  option "with-perl", "Build PerlMagick; provides the Graphics::Magick module"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended
  depends_on "little-cms2" => :optional
  depends_on "jasper" => :optional
  depends_on "libwmf" => :optional
  depends_on "ghostscript" => :optional
  depends_on "webp" => :optional
  depends_on :x11 => :optional

  fails_with :llvm do
    build 2335
  end

  skip_clean :la

  def ghostscript_fonts?
    File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
  end

  def install
    quantum_depth = [8, 16, 32].select { |n| build.with? "quantum-depth-#{n}" }
    if quantum_depth.length > 1
      odie "graphicsmagick: --with-quantum-depth-N options are mutually exclusive"
    end
    quantum_depth = quantum_depth.first || 16 # user choice or default

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-shared
      --disable-static
      --with-modules
      --without-lzma
      --disable-openmp
      --with-quantum-depth=#{quantum_depth}
    ]

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--with-perl" if build.with? "perl"
    args << "--with-webp=yes" if build.with? "webp"
    args << "--without-x" if build.without? "x11"
    args << "--without-ttf" if build.without? "freetype"
    args << "--without-xml" if build.without? "svg"
    args << "--without-lcms2" if build.without? "little-cms2"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
    if build.with? "perl"
      cd "PerlMagick" do
        # Install the module under the GraphicsMagick prefix
        system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
        system "make"
        system "make", "install"
      end
    end
  end

  def caveats
    if build.with? "perl"
      <<-EOS.undent
        The Graphics::Magick perl module has been installed under:

          #{lib}

      EOS
    end
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end
