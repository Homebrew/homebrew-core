class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20161012.tar.gz"
  sha256 "a5f5c2974eb9109b607e24f06e57696d5861aaebb620fc2c132bdbac6e656351"
  revision 2
  head "https://github.com/fontforge/fontforge.git"

  bottle do
    sha256 "7761dfc6c4323b846535e40a8eab0625d5c4ce5755df649628ab29f6259b4632" => :sierra
    sha256 "db363f7a461eeb10c685fea7667ea9f03aa486ad8348cc27dffb7415a62799d2" => :el_capitan
    sha256 "072cfd2fb0c31d4083afa9079cc30d81185eab606b63e81f561ce2962acfb2fb" => :yosemite
  end

  option "with-giflib", "Build with GIF support"
  option "with-extra-tools", "Build with additional font tools"

  deprecated_option "with-gif" => "with-giflib"

  # Autotools are required to build from source in all releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
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

  resource "gnulib" do
    url "https://git.savannah.gnu.org/git/gnulib.git",
        :revision => "29ea6d6fe2a699a32edbe29f44fe72e0c253fcee"
  end

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

    # Bootstrap in every build: https://github.com/fontforge/fontforge/issues/1806
    resource("gnulib").fetch
    system "./bootstrap",
           "--gnulib-srcdir=#{resource("gnulib").cached_download}",
           "--skip-git"
    system "./configure", *args
    system "make"
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
