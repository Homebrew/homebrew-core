class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-7.0.tar.xz"
  sha256 "3c1691f68386f4d74d3ca518d19df34d82644eba1db066964e77434487a3a083"
  license "GPL-3.0-or-later"
  head "https://git.dynare.org/Dynare/dynare.git", branch: "master"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c6d06691f1df3fad95b82da06060f6b8cd0540a5a55fb595e4958078448426ea"
    sha256 cellar: :any, arm64_sequoia: "009776e9bbe11be7d8597277dff5094340832103c2ef8c4d9005dd07019b7144"
    sha256 cellar: :any, arm64_sonoma:  "7181da19a9b60621d78978526b20cbcba254ebac89eae8a57f0581495db4d32e"
    sha256 cellar: :any, sonoma:        "2636ef080cdd01465419438d0c0431c5911af60bc4e66966c44cf3a162f78b9d"
    sha256               arm64_linux:   "29de507e86be91223ed947e504ab5e801911e8a7472d13db4376bdd5806142d8"
    sha256               x86_64_linux:  "1331b5200bc99899977aa326bd212e05502a0000a7f527a01adbca11df5ebcc9"
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

  def install
    # This needs a bit of extra help in finding the Octave libraries on Linux.
    octave = Formula["octave"]
    ENV.append "LDFLAGS", "-Wl,-rpath,#{octave.opt_lib}/octave/#{octave.version.major_minor_patch}" if OS.linux?

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

    ENV.delete "CXX" # avoid overriding Octave flags
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
