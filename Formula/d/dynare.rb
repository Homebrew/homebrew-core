class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.3.tar.xz"
  sha256 "232788788a72c7bc4329eaa4e1ed24318c264095d7646622b871d6e711ff322c"
  license "GPL-3.0-or-later"
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "ba962affcd850ff14cc11142157a2f00dc83e27c29e6ba1e43b79612b276ca66"
    sha256 cellar: :any, arm64_ventura: "d2ba3a1e17fa69985f92e7f48040d95c575914fc005b1e12f53be5b112194e37"
    sha256 cellar: :any, sonoma:        "b4ab59f0eaa2afa2fc2b7b6bf9e7baa264899269d729999eed5f342d39a6a66d"
    sha256 cellar: :any, ventura:       "107fc225fe27db388fc27a04036070c923e410bad080545afd657d2909c691bc"
    sha256               x86_64_linux:  "567a9630385a717ce6cfb3f1a2d094931c8ce2049a7b5feb523e9591aa2b9af4"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  fails_with :clang do
    cause <<~EOS
      GCC is the only compiler supported by upstream
      https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    EOS
  end

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # Work around used in upstream builds which helps avoid runtime preprocessor error.
    # https://git.dynare.org/Dynare/dynare/-/blob/master/macOS/homebrew-native-arm64.ini
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # Help meson find `suite-sparse` and `slicot`
    ENV.append_path "LIBRARY_PATH", Formula["suite-sparse"].opt_lib
    ENV.append_path "LIBRARY_PATH", buildpath/"slicot/lib"

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"examples").install "examples/bkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    resource "statistics" do
      url "https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.6.5.tar.gz", using: :nounzip
      sha256 "0ea8258c92ce67e1bb75a9813b7ceb56fff1dacf6c47236d3da776e27b684cee"
    end

    ENV.cxx11
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    # Work around Xcode 15.0 ld error with GCC: https://github.com/Homebrew/homebrew-core/issues/145991
    if OS.mac? && (MacOS::Xcode.version.to_s.start_with?("15.0") || MacOS::CLT.version.to_s.start_with?("15.0"))
      ENV["LDFLAGS"] = shell_output("#{Formula["octave"].opt_bin}/mkoctfile --print LDFLAGS").chomp
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    statistics = resource("statistics")
    testpath.install statistics

    cp pkgshare/"examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~MATLAB
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    MATLAB

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end
