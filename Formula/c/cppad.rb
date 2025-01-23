class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20250000.1.tar.gz"
  sha256 "bc45eed630c1ebac3dc07ffc542eee6edf0a9fc1e94a1012a26f1fb56b5b588b"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "804ce29e59456def06957466ebab0b53b3e5de0ea8019756d72667d64776c125"
    sha256 cellar: :any,                 arm64_sonoma:  "2963c6fe20b93a467d3f8e79135ba4651e1ee16f77570798b877b593136e96e3"
    sha256 cellar: :any,                 arm64_ventura: "0fb75ae5f085e6358d42e77404391bf07a5010ca6a7cf69fe1c227eb324bff68"
    sha256 cellar: :any,                 sonoma:        "4ce3a5cc7c7eced61a302b92e12c07d2d614bc06d02f1294903597ea0558314f"
    sha256 cellar: :any,                 ventura:       "78c1eb050f3759a306146088948493257eb1d435975df7aa13c9829acd5abce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ddb04fa32b2608ef40101ed22bf49f0a9a03e119f7434a6ff89dba437f47fc"
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
