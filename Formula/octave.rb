class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-4.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/octave/octave-4.2.2.tar.gz"
  sha256 "77b84395d8e7728a1ab223058fe5e92dc38c03bc13f7358e6533aab36f76726e"
  revision 1

  bottle do
    sha256 "2b9a58f068571831811df59450af5eb8112a2d697b48912fefcb8b9a392c2f56" => :high_sierra
    sha256 "f8b700bc410e71fe6cac07dbabe2140c12a6cbbe28787004d4b452c677c617f4" => :sierra
    sha256 "cf7821b99fff1562be01978ee37f9f33fec448e22cd501e4bd7ab0b3ac447884" => :el_capitan
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", :branch => "default", :using => :hg
    depends_on "mercurial" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
    depends_on "sundials"
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "epstool"
  depends_on "fftw"
  depends_on "fig2dev"
  depends_on "fltk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
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
  depends_on :java => ["1.6+", :optional]

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    # allow for recent Oracle Java (>=1.8) without requiring the old Apple Java 1.6
    # this is more or less the same as in https://savannah.gnu.org/patch/index.php?9439
    inreplace "libinterp/octave-value/ov-java.cc",
      "#if ! defined (__APPLE__) && ! defined (__MACH__)", "#if 1" # treat mac's java like others
    inreplace "configure.ac",
      "-framework JavaVM", "" # remove framework JavaVM as it requires Java 1.6 after build

    inreplace "scripts/java/module.mk",
      "-source 1.3 -target 1.3", "" # necessary for Java >1.8

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-link-all-dependencies
      --enable-shared
      --disable-static
      --disable-docs
      --without-OSMesa
      --without-qt
      --with-hdf5-includedir=#{Formula["hdf5"].opt_include}
      --with-hdf5-libdir=#{Formula["hdf5"].opt_lib}
      --with-x=no
      --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort
      --with-portaudio
      --with-sndfile
    ]

    args << "--disable-java" if build.without? "java"

    if build.head?
      system "./bootstrap"
    else
      system "autoreconf", "-fiv"
    end

    system "./configure", *args
    system "make", "all"

    # Avoid revision bumps whenever fftw's or gcc's Cellar paths change
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test java bindings: check if javaclasspath is working, return error if not
    system bin/"octave", "--eval", "try; javaclasspath; catch; quit(1); end;" if build.with? "java"
  end
end
