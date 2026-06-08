class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://octave.org/index.html"
  url "https://ftpmirror.gnu.org/gnu/octave/octave-11.3.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/octave/octave-11.3.0.tar.xz"
  sha256 "2b80f3149b2de6d1f4f2fcb4fe6515a17eb363b52111bf57b90f37bf6f5e12e1"
  license "GPL-3.0-or-later"
  compatibility_version 2

  # New tarballs appear on https://ftp.gnu.org/gnu/octave/ before a release is
  # announced, so we check the octave.org download page instead.
  livecheck do
    url "https://octave.org/download"
    regex(%r{Octave\s+v?(\d+(?:\.\d+)+)(?:\s*</[^>]+?>)?\s+is\s+the\s+latest\s+stable\s+release}im)
  end

  bottle do
    sha256 arm64_tahoe:   "21478720ff7b18bce4f4c47dcb686e519d5e080fe8838d86d70bc7a1a2c83783"
    sha256 arm64_sequoia: "439fc043dbb70cd87d3d66e2e805abc2ec7fd683aefe4900b111b5e62190f70e"
    sha256 arm64_sonoma:  "357e7516740b000e94df2e7f2cc0b3dc561a72e7d68d4e1c54db6576d022bad1"
    sha256 sonoma:        "975683d6d6a0e8685ed1de8de58b46ebd19d52b4a026b979e55939b9440f712b"
    sha256 arm64_linux:   "fb36c9a361435234b78e2a6885edfeff32402eb7acd1484cc59f468805f7b53f"
    sha256 x86_64_linux:  "336964b205919254814ff50059f08feb887bfead0a8e8db0df34a0c767124aed"
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
