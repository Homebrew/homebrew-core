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
    rebuild 1
    sha256 arm64_tahoe:   "dd3e934bb9760b775520968d4427efd88af85f1e30ac179b9ee274e69a8b6d65"
    sha256 arm64_sequoia: "9b3c413e48d96a1ab083b21aaa46a445ce66f383a317a403c5e6c96123b2a36c"
    sha256 arm64_sonoma:  "f180b9a2804c0ea11642650743cadffa7eac78395f7f27e7faa4a32fd121114b"
    sha256 sonoma:        "4f8f068612a8799a6565fa081eb2a6e8fc1f3dd7c64920fc19057ab8b2bc00f7"
    sha256 arm64_linux:   "37a808b18b16d29308da0bf4837aa6c65e2b5e76bef081f68fa3feb6f63c766d"
    sha256 x86_64_linux:  "b2ca79f1d0ec0d7f0a11a9c7a844519b801f3704f1b7a8d6d47fa3d8f3759e9d"
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
    depends_on "libx11"
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
      "--with-blas=-L#{formula_opt_lib("openblas")} -lopenblas",
      "--with-portaudio",
      "--with-sndfile",
    ]
    args << "--with-x=no" if OS.mac?

    system "./configure", *args, *std_configure_args
    # https://github.com/Homebrew/homebrew-core/pull/170959#issuecomment-2351023470
    ENV.deparallelize do
      system "make", "all"
    end

    # Avoid revision bumps whenever fftw's, gcc's or OpenBLAS' Cellar paths change
    fftw_prefix = formula_opt_prefix("fftw")
    gcc_prefix = formula_opt_prefix("gcc")
    inreplace "src/mkoctfile.cc" do |s|
      s.gsub! fftw_prefix.realpath, fftw_prefix
      s.gsub! gcc_prefix.realpath, gcc_prefix
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

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    pid = spawn(bin/"octave", "--gui")
    begin
      sleep 5
    ensure
      system "pkill", "-KILL", "octave-gui"
      Process.wait(pid)
    end
  end
end
