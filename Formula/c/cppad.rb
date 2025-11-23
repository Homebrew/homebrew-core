class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://cppad.readthedocs.io/latest/"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20250000.2.tar.gz"
  sha256 "d6688c7530913dfd286f7db71b007fd96df10a9e8b43ad74539e4450c9917ebf"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77cd98371fd178e41517c2cc91dcddd126557de19b9d4c4799924c715c0c47ee"
    sha256 cellar: :any,                 arm64_sequoia: "6f65c18d0662a88d692f107f438a055b1f2668d5ec7416e563b88b482db789f8"
    sha256 cellar: :any,                 arm64_sonoma:  "617a8aad764f2c8c33d8e3a252cffaed40eeda79e2248bd7590b254c3053f242"
    sha256 cellar: :any,                 arm64_ventura: "4b210a927c2c5f55f16ebf358b83ad441d7931b616ee3c72525513db2aff1ba1"
    sha256 cellar: :any,                 sonoma:        "be977a43d7368711e1cdba74d19b0a9d14babf25c9cccafb98cc28c2ed83725a"
    sha256 cellar: :any,                 ventura:       "cf71330f98f3ec66673d6475e72b5521656149487d9181f4b11c54703b4e94d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e490b1de9def38d581e819d73a01f770be148c6ae6541a987a7ab92e9a2b2b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b72d08633d4877ffe165ccdc0569d2c5ba34607534b93d395b52ab1a4aefe882"
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
