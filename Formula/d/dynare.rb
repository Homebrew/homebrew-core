class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-7.2.tar.xz"
  sha256 "88204354739547117b315e8fa3f8780a7570c576efd12f6a292f2a2468bb7a3c"
  license "GPL-3.0-or-later"
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9d60b4eb9f0eaf743eb983afd8b40f67f28ac75a341629915185cc31a6cc952"
    sha256 cellar: :any, arm64_tahoe:       "a7d679ac8ae6db252d57b08a64ab27c6f17c58b0dad96da0ddbde33ac1ea4e8f"
    sha256 cellar: :any, arm64_sequoia:     "32945dee7315fb4ee957da7f6141d9fa11b9493de6902046d3e3cd72c42b57a0"
    sha256 cellar: :any, arm64_linux:       "9dcfa28f62c487f2ae84a175f680a012c8c82e0c87859c16fc30a09bd4a76d24"
    sha256 cellar: :any, x86_64_linux:      "d7286b476eb7f52e34c871205340786a4516d0d9cbbda5f50f83a3c457bbb106"
  end

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "libmatio"
  depends_on "octave"
  depends_on "openblas"
  depends_on "slicot"
  depends_on "suite-sparse"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "libomp"

    # Work around LLVM issue with structured bindings[^1] by partly reverting commit[^2].
    # Upstream isn't planning to support Clang build[^3] but we need it to use a consistent OpenMP.
    # [^1]: https://github.com/llvm/llvm-project/issues/33025
    # [^2]: https://git.dynare.org/Dynare/dynare/-/commit/6ff7d4c56c26a2b7546de633dbcfe2f163bf846d
    # [^3]: https://git.dynare.org/Dynare/dynare/-/issues/1977
    patch do
      file "Patches/dynare/clang.diff"
      type :unofficial
    end
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700 # for std::jthreads
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  fails_with :gcc do
    version "12"
    cause "needs GCC >= 13 for C++20 features"
  end

  def install
    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    if OS.linux?
      ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}"
      ENV["BOOST_ROOT"] = formula_opt_prefix("boost").to_s
    end

    system "meson", "setup", "build", "-Dbuild_for=octave", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"examples").install "tests/model_info/bkk.mod"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    resource "datatypes" do
      url "https://github.com/pr0m1th3as/datatypes/releases/download/release-1.2.3/datatypes-1.2.3.tar.gz",
          using: :nounzip
      sha256 "2dbd6e0140354c069227412c495cbde975d088ca71d964117371735be4646c72"
    end

    resource "statistics" do
      url "https://github.com/gnu-octave/statistics/archive/refs/tags/release-1.7.3.tar.gz", using: :nounzip
      sha256 "570d52af975ea9861a6fb024c23fc0f403199e4b56d7a883ee6ca17072e26990"
    end

    ENV.delete "CXX" # avoid overriding Octave flags
    ENV.delete "LDFLAGS" # avoid overriding Octave flags

    datatypes = resource("datatypes")
    statistics = resource("statistics")
    testpath.install datatypes
    testpath.install statistics

    cp pkgshare/"examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~MATLAB
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install datatypes-#{datatypes.version}.tar.gz
      pkg install statistics-release-#{statistics.version}.tar.gz
      dynare bkk.mod console
    MATLAB

    system formula_opt_bin("octave")/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end
