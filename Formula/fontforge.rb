class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20161001.tar.gz"
  sha256 "103af2a6c8799390f20790e44064ea4f9ec6795255b7a065b3f9a352c2723c40"
  head "https://github.com/fontforge/fontforge.git"

  bottle do
    sha256 "aeeb0031067149f9795f9aac5bf3b623ab53557345509086de1124cd941b0ad8" => :sierra
    sha256 "e25c8e3ca59b9cc7ee4ece35b46d2bc95757aab7d8d800b4af4afe2b7a6dd5ed" => :el_capitan
    sha256 "e5e8e6a5522841bccf8dc4fbfd4953b35e5375320785474ddd0dc7aa066b1fcb" => :yosemite
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
  depends_on "zeromq"
  depends_on "czmq"
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

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
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
