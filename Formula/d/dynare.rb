class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-6.4.tar.xz"
  sha256 "9865e2e7f6b3705155538d5fb1fb0b01bc9decf07250b3b054d3555d651c3843"
  license "GPL-3.0-or-later"
  revision 2
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "f8e8a2c036bc5c3dae19b0c928936c424499bccf8059f1eb58e247ec349ba2ab"
    sha256 cellar: :any, arm64_ventura: "948c9c2169b07c7f69ba0b46dd85f84e7a6c6765a8aab7a5aff4a3c14cde8b61"
    sha256 cellar: :any, sonoma:        "ef2157fe6556619e676f697ef14dc59cdd815d8da820eb64e8d5dbd8c7d9e997"
    sha256 cellar: :any, ventura:       "a46f9093f5999e6b35cb8049347e98285059c29c75db1ea19e22085f4a39eb67"
    sha256               x86_64_linux:  "98253a5506492a3afcf9adcad5d56e2a79d50531a422fd66cf7a9a5513e79266"
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

  on_macos do
    depends_on "libomp"
  end

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

    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

    # Help meson find `suite-sparse` and `slicot`
    ENV.append_path "LIBRARY_PATH", Formula["suite-sparse"].opt_lib
    ENV.append_path "LIBRARY_PATH", buildpath/"slicot/lib"

    # Workaround to unofficially link to LLVM OpenMP (libomp) with GCC
    if OS.mac?
      inreplace "meson.build", "openmp_dep = dependency('openmp')",
                               "openmp_dep = declare_dependency(compile_args : '-fopenmp', link_args : '-lomp')"
    end

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
