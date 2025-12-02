class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.5.tar.xz"
  sha256 "56a6f934f5d2ded57206d2f109975324b39586394f4e8ce23b3c72aadcd5cd4a"
  license "GPL-3.0-or-later"
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "18c5adf1dd2b462bf76c91cd0689ecb68b39139d7ffb9617a742fe05184db807"
    sha256 cellar: :any, arm64_sequoia: "c2be8ed76b794b70e41e823f14a19cf216f70c43294e86270ae7b5363b54fcf9"
    sha256 cellar: :any, arm64_sonoma:  "794f3c8a3172acba252bda3ad0a2aea5f4efecb4e4b73ac2b10a2b7c4d7a25f4"
    sha256 cellar: :any, sonoma:        "ca1b81a8004d608901b9340aad1ac774d3bd4ddde4df31f04153664fa45984ee"
    sha256               arm64_linux:   "7572998a297a61c8e5bfa26a4d83edc22a547765431f73643d4759abb678ce45"
    sha256               x86_64_linux:  "37c914973788438a0eb6ecb15b4c5e6668a017b6b5457061d37618ff4168384c"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
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

    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

    # Help meson find `boost`, `suite-sparse` and `slicot`
    ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix
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
      url "https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.7.3.tar.gz", using: :nounzip
      sha256 "570d52af975ea9861a6fb024c23fc0f403199e4b56d7a883ee6ca17072e26990"
    end

    ENV.cxx
    ENV.append "CXXFLAGS", "-std=c++17" # octave >= 10 requires c++17
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

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
