class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20161005/fontforge-dist-20161004.tar.gz"
  sha256 "ccba2d84cf009e2a51656af4e0191c6a95aa1a63e5dfdeb7423969c889a24a64"

  bottle do
    sha256 "aeeb0031067149f9795f9aac5bf3b623ab53557345509086de1124cd941b0ad8" => :sierra
    sha256 "e25c8e3ca59b9cc7ee4ece35b46d2bc95757aab7d8d800b4af4afe2b7a6dd5ed" => :el_capitan
    sha256 "e5e8e6a5522841bccf8dc4fbfd4953b35e5375320785474ddd0dc7aa066b1fcb" => :yosemite
  end

  head do
    url "https://github.com/fontforge/fontforge.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build

    resource "gnulib" do
      url "git://git.savannah.gnu.org/gnulib.git",
        :revision => "29ea6d6fe2a699a32edbe29f44fe72e0c253fcee"
    end
  end

  option "with-giflib", "Build with GIF support"
  option "with-extra-tools", "Build with additional font tools"

  deprecated_option "with-gif" => "with-giflib"

  depends_on :x11 => :optional
  if build.with? "x11"
    depends_on "cairo" => "with-x11"
    depends_on "pango" => "with-x11"
  else
    depends_on "cairo"
    depends_on "pango"
  end
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "gettext"
  depends_on "zeromq"
  depends_on "czmq"
  depends_on "fontconfig"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libspiro" => :recommended
  depends_on "libuninameslist" => :recommended
  depends_on "giflib" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = `python-config --ldflags`.chomp

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--without-x" if build.without? "x11"
    args << "--without-libpng" if build.without? "libpng"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"
    args << "--without-libuninameslist" if build.without? "libuninameslist"

    # Fix linker error; see: https://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    if build.head?
      resource("gnulib").fetch
      system "./bootstrap",
             "--gnulib-srcdir=#{resource("gnulib").cached_download}",
             "--skip-git"
    end
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

    As a last resort, you may try the *unsupported* option:
      brew install fontforge --with-x11
    EOS
  end

  test do
    system bin/"fontforge", "-version"
    system "python", "-c", "import fontforge"
  end
end
