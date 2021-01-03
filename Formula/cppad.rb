class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.1.tar.gz"
  sha256 "8cebe16b9af52be73305d3af75a4bc6e68e2a18175fce6c92ec1169b1b0d7e3c"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "23d98b424d2feebedf1ff91fb5ad9373c0dfa41701196e6e9ae4ab4fa611cdfe" => :big_sur
    sha256 "5bf2eb6cd8c96bb9cc3e2d4d86ce4e0c946481a0406165312cf250fb1fd41c8c" => :arm64_big_sur
    sha256 "21c85b34b6305d55e8c91cb8a9ffef087cf0bd0c82159f9b4e4a13e0f5c3b14b" => :catalina
    sha256 "cab9a4d88d9342f2789ad085c526aa91a4cb1d24a181fb758bc88b4a4333b26b" => :mojave
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
