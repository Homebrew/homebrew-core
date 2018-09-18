class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "http://www.graphicsmagick.org/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.30/GraphicsMagick-1.3.30.tar.xz"
  sha256 "d965e5c6559f55eec76c20231c095d4ae682ea0cbdd8453249ae8771405659f1"
  head "http://hg.code.sf.net/p/graphicsmagick/code", :using => :hg

  bottle do
    sha256 "cdaf146d656352ce0cbca35f097f55065499340e9383a807b83d4390a46fe531" => :mojave
    sha256 "701f65ee9855e57d1801bcb9e506cfe4ea559e0d91d80a2d3353114f567e1b05" => :high_sierra
    sha256 "16d2ca5041f489588fe34683c114190a3f7aeaf7ec9e75eab1f69b69f04d2850" => :sierra
    sha256 "3bfb42383538f63bb9ede1efe7b74517283e8f23aeb37727da8d747dc7bc9165" => :el_capitan
  end

  option "with-perl", "Build PerlMagick; provides the Graphics::Magick module"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "ghostscript" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms2" => :optional
  depends_on "webp" => :optional
  depends_on :x11 => :optional

  skip_clean :la

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-shared
      --disable-static
      --with-modules
      --without-lzma
      --disable-openmp
      --with-quantum-depth=16
    ]

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--with-perl" if build.with? "perl"
    args << "--with-webp=no" if build.without? "webp"
    args << "--without-x" if build.without? "x11"
    args << "--without-lcms2" if build.without? "little-cms2"
    args << "--without-wmf" if build.without? "libwmf"

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
      <<~EOS
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
