class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.46.1/ns-3-dev-ns-3.46.1.tar.gz"
  sha256 "3cb25d4ce1fb5c8597c91ab3d14c52a9f37eff92c36c2961772966c440850171"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "f5b12412aa2879bbc0c58aa2cb6f4856287cb5c3bd6a50c2e7ab450a70aebea2"
    sha256                               arm64_sequoia: "0171d128dac59723f0744b418963b211d46c7294df76f20c1a501cb4cae64d7b"
    sha256                               arm64_sonoma:  "83247717e3fb87de6793c2ab34dab43992e05361c0b5fd414e659662cbabcce0"
    sha256                               sonoma:        "95b426f45d078af9c3cbbb98fa11c276e6dfa2d1c48dd9f8424d5026eb279a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b78802a98d2bfbe8b5c19420b9975af724a83f8b70fdee08944ddd1543cac67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3182a93ec5baf35b4d33357235fcc0ba712c4e10eb036b4330961dcbfe32a047"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix to error: no matching function for call to ‘find...’
    # Issue ref: https://gitlab.com/nsnam/ns-3-dev/-/issues/1264
    inreplace "src/core/model/test.cc", "#include <vector>", "#include <vector>\n#include <algorithm>"

    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    args = %W[
      -DNS3_GTK3=OFF
      -DNS3_PYTHON_BINDINGS=OFF
      -DNS3_MPI=ON
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/tutorial/first.cc"
  end

  test do
    system ENV.cxx, "-std=c++20", "-o", "test", pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications"
    system "./test"
  end
end
