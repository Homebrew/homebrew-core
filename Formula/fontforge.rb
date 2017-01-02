class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20161012.tar.gz"
  sha256 "a5f5c2974eb9109b607e24f06e57696d5861aaebb620fc2c132bdbac6e656351"
  head "https://github.com/fontforge/fontforge.git"

  bottle do
    sha256 "ee5a2a154bf5b1ab8761c79eb2671b2959306d3ae9d47075a1bbc24976ba80bc" => :sierra
    sha256 "929d48bace95a3ae1294b54303499a0e3f5dbaaeeec5dac259c5edbc875cd846" => :el_capitan
    sha256 "8fa8ab443af4f0ffa3378056878a7244a961dc5e977f71cbb1fe0e5d4f894cfd" => :yosemite
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
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "libspiro" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  resource "gnulib" do
    url "git://git.savannah.gnu.org/gnulib.git",
        :revision => "29ea6d6fe2a699a32edbe29f44fe72e0c253fcee"
  end

  def install
    # Don't link libraries to libpython, but do link binaries that expect
    # to embed a python interpreter
    # https://github.com/fontforge/fontforge/issues/2353#issuecomment-121009759
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    python_libs = `python2.7-config --ldflags`.chomp
    inreplace "fontforgeexe/Makefile.am" do |s|
      oldflags = s.get_make_var "libfontforgeexe_la_LDFLAGS"
      s.change_make_var! "libfontforgeexe_la_LDFLAGS", "#{python_libs} #{oldflags}"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --with-pythonbinary=#{which "python2.7"}
      --without-x
    ]

    args << "--without-libpng" if build.without? "libpng"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"

    # Fix linker error; see: https://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

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
    system "python", "-c", "import fontforge"
  end
end
