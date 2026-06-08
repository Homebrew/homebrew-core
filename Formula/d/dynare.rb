class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-7.1.tar.xz"
  sha256 "fdd294a99c67c81208da8d682bf12e68fdbda75012b218d8702a4de163058a4e"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "edb01020ea75b2549dbac94e452f57b1849c8797be344215161182e2667bb7eb"
    sha256 cellar: :any, arm64_sequoia: "d28bb114a5897ade6fe0590fc587cc5a5a878819e475f4bcddb94b539f68e17b"
    sha256 cellar: :any, arm64_sonoma:  "8ec14189bdf0be7d4cd327be0d7e9edb0285af4083aafbaca66cd788b730aa4f"
    sha256 cellar: :any, sonoma:        "06fc4ff606f076fcb43365515f26e238c11bc2b4ca6e08cf9e74fb19df237a2c"
    sha256               arm64_linux:   "7f1752b6e8b7a4d08100ccda65672294a0197855c80731b17abd382b27367580"
    sha256               x86_64_linux:  "afbee497e701fd6e60c1984e2fc54ee5d5e400154dcc14e22bf379d1a248dae2"
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
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/c49717c390cb2e587793b2db757c1f445f096219/Patches/dynare/clang.diff"
      sha256 "2d174336fc8db4d8989cda214a972ef49c6302bb12a64d717140869e546e17d0"
    end
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] # for std::jthreads
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
      ENV["BOOST_ROOT"] = Formula["boost"].opt_prefix.to_s
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

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "--no-history", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end
