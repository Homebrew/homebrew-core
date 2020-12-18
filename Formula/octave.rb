class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "https://ftp.gnu.org/gnu/octave/octave-6.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/octave/octave-6.1.0.tar.xz"
  sha256 "d6cd6b79ef023e300b9287b56aa79333cfb6b651771d43ade7cbde63ca5a6010"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "be7e3a520db1d6c684120effd115170f49d2cf41c4ee24a9e17af349ef3f9db2" => :big_sur
    sha256 "7a2372bb936b1b09db7deb5b8f39a777a03f5f8238a4a4be4434f27deb4d1d52" => :catalina
    sha256 "08d3f28fda600a60b0f0759efaf5b6e2f56124de3d2822758fbf1ba5caaad01f" => :mojave
  end

  head do
    url "https://hg.savannah.gnu.org/hgweb/octave", branch: "default", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "openjdk" => :build
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
  depends_on "openblas"
  depends_on "pcre"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "qscintilla2"
  depends_on "qt"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"

  uses_from_macos "curl"

  # Dependencies use Fortran, leading to spurious messages about GCC
  cxxstdlib_check :skip

  def install
    # Default configuration passes all linker flags to mkoctfile, to be
    # inserted into every oct/mex build. This is unnecessary and can cause
    # cause linking problems.
    inreplace "src/mkoctfile.in.cc",
              /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/,
              '""'

    # Qt 5.12 compatibility
    # https://savannah.gnu.org/bugs/?55187
    ENV["QCOLLECTIONGENERATOR"] = "qhelpgenerator"
    # These "shouldn't" be necessary, but the build breaks without them.
    # https://savannah.gnu.org/bugs/?55883
    ENV["QT_CPPFLAGS"]="-I#{Formula["qt"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["qt"].opt_include}"
    ENV["QT_LDFLAGS"]="-F#{Formula["qt"].opt_lib}"
    ENV.append "LDFLAGS", "-F#{Formula["qt"].opt_lib}"

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-link-all-dependencies",
                          "--enable-shared",
                          "--disable-static",
                          "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
                          "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
                          "--with-java-homedir=#{Formula["openjdk"].opt_prefix}",
                          "--with-x=no",
                          "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
                          "--with-portaudio",
                          "--with-sndfile"
    system "make", "all"

    # Avoid revision bumps whenever fftw's, gcc's or OpenBLAS' Cellar paths change
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
    # This is supposed to crash octave if there is a problem with BLAS
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
