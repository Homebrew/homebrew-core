class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz"
  sha256 "840adefbedd1717e6b70b33ad1e7f2b116678fa6a3d52d45316793b9fd808822"
  revision 1

  bottle do
    sha256 "c5f796bec473c8e3a365c793b9c581725d516b2a63907ace8d0085e4de02a97d" => :sierra
    sha256 "6816df4e681a07432b50199a512585d0b4025d3030c3e8719465c135fcfabc50" => :el_capitan
    sha256 "7d8cfe9ef3650fa1ed45fbd536b8ba35d78aa58f0a53a1f8af1840f4be14567d" => :yosemite
  end

  option "with-giflib", "Build with GIF support"
  option "with-extra-tools", "Build with additional font tools"

  deprecated_option "with-gif" => "with-giflib"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "gettext"
  depends_on "pango"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "libspiro" => :optional
  depends_on "libuninameslist" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = `python-config --ldflags`.chomp

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --without-x
    ]

    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"
    args << "--without-libuninameslist" if build.without? "libuninameslist"

    system "./configure", *args
    system "make", "install"

    # The app here is not functional.
    # If you want GUI/App support, check the caveats to see how to get it.
    (pkgshare/"osx/FontForge.app").rmtree

    if build.with? "extra-tools"
      cd "contrib/fonttools" do
        system "make"
        bin.install Dir["*"].select { |f| File.executable? f }
      end
    end
  end

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.

    FontForge.app can be downloaded directly from the website:
      https://fontforge.github.io

    Alternatively, install with Homebrew-Cask:
      brew cask install fontforge
    EOS
  end

  test do
    system bin/"fontforge", "-version"
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    system "python", "-c", "import fontforge"
  end
end
