class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20240000.4.tar.gz"
  sha256 "0dfc1e30b32d5dd3086ee3adb6d2746a019e9d670b644c4d5ec1df3c35dd1fe5"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f81c9a4c3dea26bbf00bad06c6be44ea4081b3ca0fbc500fd4ef449d21841856"
    sha256 cellar: :any,                 arm64_ventura:  "917736ef1144c421b043332b57ec8adae536cd21514c375411e3b44295f1c159"
    sha256 cellar: :any,                 arm64_monterey: "c99a64bdb006dcb16aa4a486cbd96e47846d32eb8f1cbaeb53d1232c0e93f71b"
    sha256 cellar: :any,                 sonoma:         "a846194fbced623c0212a95bb228eaff0040d56a132acff770d6a1d9bb8cf491"
    sha256 cellar: :any,                 ventura:        "ae729f2b25f440dbc2b8c536bf7de096e69f7b6e98b69b21d5c209fb2d285e02"
    sha256 cellar: :any,                 monterey:       "dc9bc39f08016b94b65d461db4bbfb371d6831749441f9ea9f4360bc15237d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770166b758af6083740b28d5b0acbd6a78c22683476388d0ed7eeb60dc5e95c4"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
