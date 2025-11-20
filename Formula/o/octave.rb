class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://octave.org/index.html"
  url "https://ftpmirror.gnu.org/gnu/octave/octave-10.3.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/octave/octave-10.3.0.tar.xz"
  sha256 "92ae9bf2edcd288bd2df9fd0b4f7aa719b49d3940fceb154c5fdcd846f254da1"
  license "GPL-3.0-or-later"

  # New tarballs appear on https://ftp.gnu.org/gnu/octave/ before a release is
  # announced, so we check the octave.org download page instead.
  livecheck do
    url "https://octave.org/download"
    regex(%r{Octave\s+v?(\d+(?:\.\d+)+)(?:\s*</[^>]+?>)?\s+is\s+the\s+latest\s+stable\s+release}im)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b83eb0676410572173c4befc49beba4c53e92ff6545cfb4f657f883afe01878c"
    sha256 arm64_sequoia: "ed8eda61e1ee0492801d0a225cbf40ade65ac3b5c68ab8a2389e2c2eb0cf0579"
    sha256 arm64_sonoma:  "a89a037602534ba7adc2fb70b77e349f060937b7c4d712c3eee36efc3183933a"
    sha256 sonoma:        "35659321f8828b5d1230cfef3c2749d410f9ddbbbaab930bdc1c8828c5764af9"
    sha256 arm64_linux:   "b94f07bd3afea2a67f7de94e08559a136aa5099e7f23b16f7ab31327da5ef57a"
    sha256 x86_64_linux:  "23344131734979e1bafde92e0442a0b4ad74dd0b126c9e8644acd06aea65ad3d"
  end

  head do
    url "https://hg.octave.org/octave", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "icoutils" => :build
    depends_on "librsvg" => :build
  end

  # Complete list of dependencies at https://wiki.octave.org/Building
  depends_on "gnu-sed" => :build # https://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
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
  depends_on "graphicsmagick"
  depends_on "hdf5"
  depends_on "libsndfile"
  depends_on "libtool"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "portaudio"
  depends_on "pstoedit"
  depends_on "qhull"
  depends_on "qrupdate"
  depends_on "qscintilla2"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qttools"
  depends_on "rapidjson"
  depends_on "readline"
  depends_on "suite-sparse"
  depends_on "sundials"
  depends_on "texinfo"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "autoconf"
    depends_on "automake"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Workaround until release with https://hg.octave.org/octave/rev/8cf9d5e68c96
    inreplace "configure", " --cflags-only-I $QT_", " --cflags $QT_" if build.stable?

    system "./bootstrap" if build.head?
    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--disable-static",
      "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}",
      "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}",
      "--with-java-homedir=#{Formula["openjdk"].opt_prefix}",
      "--with-x=no",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-portaudio",
      "--with-sndfile",
    ]

    if OS.linux?
      # Explicitly specify aclocal and automake without versions
      args << "ACLOCAL=aclocal"
      args << "AUTOMAKE=automake"

      # Mesa OpenGL location must be supplied by LDFLAGS on Linux
      args << "LDFLAGS=-L#{Formula["mesa"].opt_lib} -L#{Formula["mesa-glu"].opt_lib}"

      # Docs building is broken on Linux
      args << "--disable-docs"

      # Need to regenerate aclocal.m4 so that it will work with brewed automake
      system "aclocal"
    end

    system "./configure", *args, *std_configure_args
    # https://github.com/Homebrew/homebrew-core/pull/170959#issuecomment-2351023470
    ENV.deparallelize do
      system "make", "all"
    end

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
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # This is supposed to crash octave if there is a problem with BLAS
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
    # Test basic compilation
    (testpath/"oct_demo.cc").write <<~CPP
      #include <octave/oct.h>
      DEFUN_DLD (oct_demo, args, /*nargout*/, "doc str")
      { return ovl (42); }
    CPP
    system bin/"octave", "--eval", <<~MATLAB
      mkoctfile ('-v', '-std=c++17', '-L#{lib}/octave/#{version}', 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB
    # Test FLIBS environment variable
    system bin/"octave", "--eval", <<~MATLAB
      args = strsplit (mkoctfile ('-p', 'FLIBS'));
      args = args(~cellfun('isempty', args));
      mkoctfile ('-v', '-std=c++17', '-L#{lib}/octave/#{version}', args{:}, 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system bin/"octave", "--gui"
  end
end
