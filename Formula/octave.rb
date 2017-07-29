class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-4.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/octave/octave-4.2.1.tar.gz"
  sha256 "80c28f6398576b50faca0e602defb9598d6f7308b0903724442c2a35a605333b"

  bottle do
    rebuild 1
    sha256 "24c5f5ef09a81bc833b97a68a226be07619a1e71b148a275a25e5e61b88fb8ed" => :sierra
    sha256 "dcc5f40a1b06b6235892481df9be93243106ad5b7c12a2cbbbd5b06d81620765" => :el_capitan
    sha256 "5a20e1c89bdb9a6b993e536ce7f3751d4e90cfdf309b6f015ade3e754165497e" => :yosemite
  end

  head do
    url "http://www.octave.org/hg/octave", :branch => "default", :using => :hg
    depends_on :hg => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  depends_on "gnu-sed" => :build # http://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "pkg-config" => :build
  depends_on :fortran
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "gl2ps"
  depends_on "glpk"
  depends_on "gnuplot"
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool" => :run
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "veclibfort"

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  # If GraphicsMagick was built from source, it is possible that it was
  # done to change quantum depth. If so, our Octave bottles are no good.
  # https://github.com/Homebrew/homebrew-science/issues/2737
  def pour_bottle?
    Tab.for_name("graphicsmagick").without?("quantum-depth-32") &&
      Tab.for_name("graphicsmagick").without?("quantum-depth-8")
  end

  def install
    if build.stable?
      # Remove for > 4.2.1
      # Remove inline keyword on file_stat destructor which breaks macOS
      # compilation (bug #50234).
      # Upstream commit from 24 Feb 2017 http://hg.savannah.gnu.org/hgweb/octave/rev/a6e4157694ef
      inreplace "liboctave/system/file-stat.cc",
        "inline file_stat::~file_stat () { }", "file_stat::~file_stat () { }"
    end

    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-link-all-dependencies",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-docs",
                          "--disable-java",
                          "--without-OSMesa",
                          "--without-qt",
                          "--with-x=no",
                          "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort",
                          "--with-portaudio",
                          "--with-sndfile"
    system "make", "all"
    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # this is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
