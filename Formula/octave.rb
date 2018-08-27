class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-4.4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-4.4.1.tar.xz"
  sha256 "7e4e9ac67ed809bd56768fb69807abae0d229f4e169db63a37c11c9f08215f90"
  revision 1

  bottle do
    sha256 "87db66946554f51ed6262374bcdb9cb6305dd7eee92b4f7eeccc0753fa82b50d" => :high_sierra
    sha256 "d35b841df256eadcd0ab74da2dae20f9e6064e7580930c5878f5d3525d9ad16d" => :sierra
    sha256 "cb50ca8777de46163a9f9dc9431deae955c49092815801113d0cf008d4ed4294" => :el_capitan
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", :branch => "default", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on :java => ["1.6+", :build, :test]
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
  depends_on "libtool"
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"
  depends_on "veclibfort"

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-link-all-dependencies",
                          "--enable-shared",
                          "--disable-static",
                          "--without-osmesa",
                          "--without-qt",
                          "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
                          "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
                          "--with-x=no",
                          "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort",
                          "--with-portaudio",
                          "--with-sndfile"
    system "make", "all"

    # Avoid revision bumps whenever fftw's or gcc's Cellar paths change
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! Formula["fftw"].prefix.realpath, Formula["fftw"].opt_prefix
      s.gsub! Formula["gcc"].prefix.realpath, Formula["gcc"].opt_prefix
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath/"scripts/startup/site-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{Formula["texinfo"].opt_bin}/makeinfo\");"

    system "make", "install"
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test java bindings: check if javaclasspath is working, return error if not
    system bin/"octave", "--eval", "try; javaclasspath; catch; quit(1); end;"
  end
end
