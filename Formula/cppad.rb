class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20220000.1.tar.gz"
  sha256 "e12a66d8af43b5df1674f1b0cb6f84ed64d3e39198dd6fb0411543f499b13289"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b3492069433e3a021592e28545e3908b70f739ab8956fd25cbac5c40c1ca30c"
    sha256 cellar: :any,                 arm64_big_sur:  "5df1f3c081461d585ee499b1d6882e56fd8d1767781ec20e29a6d838719358d2"
    sha256 cellar: :any,                 monterey:       "790cdd49ae604346e3288bed9bdc578774003cd483e43fa8642ce650666dd40f"
    sha256 cellar: :any,                 big_sur:        "39c72924754a7f6daaecbcd78ba7c2cc0711813d4c187b7cd239aeadbd07b022"
    sha256 cellar: :any,                 catalina:       "f719bd06a98ecc826ebff7590df7bd1d23ea8fedbc7e9ef8c9589582f3d5700a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c1972049d81606bef12b4d0c2f9ff3edb03a1cdad15914bd2eb982891f6580"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
