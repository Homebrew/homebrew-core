class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://cppad.readthedocs.io/latest/"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20260000.0.tar.gz"
  sha256 "41ec617bb1e4163da381aaa5083a152e033631e9b5e135ccdc3466aaa1dc9001"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa14284fc5488a36f4aa1dc1be45515d6d96425e4ce6156117a67de19affcc1c"
    sha256 cellar: :any,                 arm64_sequoia: "39b11c1f3ff357ee7719ac3139fe5fcd26ec4d269c9e0d7ce804632ecbfc091f"
    sha256 cellar: :any,                 arm64_sonoma:  "47f1e2955ac6995a50ed0948b9f430eea2a4a06a6bb8420ee886cfc60730a399"
    sha256 cellar: :any,                 sonoma:        "cce0487a84168dc9bb427918621ffc42f61795afce0e108439b6c8e15532389e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a191c00757e8dcbb8bb90b1752deca422aa78cdd319c978d33ce84098e0a9021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43af0c723529ed52a763fa69cc12132230ae0098f7768f81554d1adf309d050c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    CPP

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
