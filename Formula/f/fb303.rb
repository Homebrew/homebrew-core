class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "993de95412962d4883437ef5a4bc94eda6b6927ffe2e083274132e3e862d10ae"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d62edee1a8bfba576c422e725b82373be3ec7509903d2944325285f50a43cad"
    sha256 cellar: :any,                 arm64_ventura:  "395cf4ca6caff6275e3d878c6515a7dfad07454a68a950eefb3a5ea9ee164100"
    sha256 cellar: :any,                 arm64_monterey: "e8625e676731567347092d6f695846c24a4b918ff7c4b2fdd87f7694559cf565"
    sha256 cellar: :any,                 sonoma:         "bf68ff4f131587094994de9b8f6f85f536e4ff81cdceaaddfb6002d55bcbf002"
    sha256 cellar: :any,                 ventura:        "baae630019a12300daf786e0f54b050faf3655dd43f7e4a7dc6d64703cde1f8e"
    sha256 cellar: :any,                 monterey:       "854d098bed03aa930a92fedf16836c21db34574f56f18dab10bb893ff7c16e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33118c07859312c64e11e24e194002a7535fce113c9bddcdebe0f7ea2340fb3e"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
