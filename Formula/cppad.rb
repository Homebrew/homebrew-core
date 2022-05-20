class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/20220000.3.tar.gz"
  sha256 "7778c516a131a20e12c97dffe2b65fbf356d791741a6c63d39f16b9c4b747259"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c3d520e2e241c46e3c00851cd18de2f9926bcf44aab38a8438213328d161b894"
    sha256 cellar: :any,                 arm64_big_sur:  "19b705f49108fab8d83f09fd9ae6429c0c6f90622e41eea6bb573fb228017548"
    sha256 cellar: :any,                 monterey:       "3762f8640dc15f82c67222c3580e9c7b2f22afe4718bfb4a094582e85cc3cd25"
    sha256 cellar: :any,                 big_sur:        "050aae4237805f0c17171b680f62f9c6800b72a00f148ad39fe313f33a35bb77"
    sha256 cellar: :any,                 catalina:       "6b4c71bc2acbafa390d4dfe2b569b2a744453c7947842dcfd5aa72a2dbb7591d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da097694f15fd7afa3bade6dd5c97ffeb400e0cf70acdfabc151b8adae00b5f"
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
