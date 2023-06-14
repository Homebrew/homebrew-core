class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "f9cdc2f6631e09707ed5f9afe8b3b9acb94b9a3c04dc896d7570a07290024292"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1dfac2486a5552ffd26f594e1b441b37f1b840563c3541fbce5c240490891756"
    sha256 cellar: :any,                 arm64_monterey: "d6ab4add4985d53d8a9a033285022903267b1b0cf5eb6d1c5e53ce60915c6b83"
    sha256 cellar: :any,                 arm64_big_sur:  "802de85ba0ca64aa0d6775d3cb21a5a6038ff14ad5820790328244bf6e0e92e3"
    sha256 cellar: :any,                 ventura:        "a724b883a113d5d0736cac38742227f616619e9294bbcc4cbc7b26bf3f4661f9"
    sha256 cellar: :any,                 monterey:       "b9f8b80cfc8a7e18923f968143795b05146234d0022593a102a0d1586b89f211"
    sha256 cellar: :any,                 big_sur:        "1b5cb71cbdc9b3eb6ea8d3ff55fa47e51f2951a249cf6018b99ccc48f9c45c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c20805847af05d185b4f674077895da943be4ff5d25020d7f90ebb3fb291c60"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
