class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://octave.org/index.html"
  url "https://ftpmirror.gnu.org/gnu/octave/octave-11.3.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/octave/octave-11.3.0.tar.xz"
  sha256 "2b80f3149b2de6d1f4f2fcb4fe6515a17eb363b52111bf57b90f37bf6f5e12e1"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 2

  # New tarballs appear on https://ftp.gnu.org/gnu/octave/ before a release is
  # announced, so we check the octave.org download page instead.
  livecheck do
    url "https://octave.org/download"
    regex(%r{Octave\s+v?(\d+(?:\.\d+)+)(?:\s*</[^>]+?>)?\s+is\s+the\s+latest\s+stable\s+release}im)
  end

  bottle do
    sha256 arm64_tahoe:   "f244857ee56ac75e318a48ecc160228ffe285d38fabb3f27730d38fc8c9c66cd"
    sha256 arm64_sequoia: "2f27b42ac0f3bedc9497a193df2f06cb583f78daa9aa1d9b2381887ca9aaab10"
    sha256 arm64_sonoma:  "4528265504f6d16e79c9f1fb3390074c8626256ed68fd7c4ae5cc1d3b976e5b6"
    sha256 sonoma:        "e79a12d1fb8c32ee94625e5273e67c25e74619372b4c29909f17c568f24d63a5"
    sha256 arm64_linux:   "d9c8c3901aacb2fd1945751c40ae927106d1179f51df31e0fedf263d670273d6"
    sha256 x86_64_linux:  "2bed748ae6fe1760aedc028b4b33285ea563cefb1f55feb6323038181559fe3f"
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

  on_macos do
    depends_on "little-cms2"
  end

  on_sequoia :or_older do
    depends_on "fast_float" => :build
  end

  on_linux do
    depends_on "autoconf"
    depends_on "automake"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap" if build.head?
    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--disable-static",
      "--with-hdf5-includedir=#{formula_opt_include("hdf5")}",
      "--with-hdf5-libdir=#{formula_opt_lib("hdf5")}",
      "--with-java-homedir=#{formula_opt_prefix("openjdk")}",
      "--with-x=no",
      "--with-blas=-L#{formula_opt_lib("openblas")} -lopenblas",
      "--with-portaudio",
      "--with-sndfile",
    ]

    if OS.linux?
      # Explicitly specify aclocal and automake without versions
      args << "ACLOCAL=aclocal"
      args << "AUTOMAKE=automake"

      # Mesa OpenGL location must be supplied by LDFLAGS on Linux
      args << "LDFLAGS=-L#{formula_opt_lib("mesa")} -L#{formula_opt_lib("mesa-glu")}"

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
      s.gsub! Formula["fftw"].prefix.realpath, formula_opt_prefix("fftw")
      s.gsub! Formula["gcc"].prefix.realpath, formula_opt_prefix("gcc")
    end

    # Make sure that Octave uses the modern texinfo at run time
    rcfile = buildpath/"scripts/startup/site-rcfile"
    rcfile.append_lines "makeinfo_program(\"#{formula_opt_bin("texinfo")}/makeinfo\");"

    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV.delete "CXX" # make sure Octave's default works without manual -std=...

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
      mkoctfile ('-v', '-L#{lib}/octave/#{version}', 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB

    # Test FLIBS environment variable
    system bin/"octave", "--eval", <<~MATLAB
      args = strsplit (mkoctfile ('-p', 'FLIBS'));
      args = args(~cellfun('isempty', args));
      mkoctfile ('-v', '-L#{lib}/octave/#{version}', args{:}, 'oct_demo.cc');
      assert(oct_demo, 42)
    MATLAB

    if OS.linux?
      ENV["QT_QPA_PLATFORM"] = "minimal"
      system bin/"octave", "--gui"
    else
      pid = spawn(bin/"octave", "--gui")
      sleep 5
      system "pkill", "-KILL", "octave-gui"
      Process.wait(pid)
    end
  end
end
