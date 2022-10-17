class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.17.00.tar.gz"
  sha256 "b4acbc00ccc627fd3b61d97d0c4b8a9909528f52313034c1739bbe2332f5afb1"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff899a728533538d509a6d444eb085b680b6ce738c0319c9d973a19ecb85b7e0"
    sha256 cellar: :any,                 arm64_big_sur:  "89f23b99cb5689112442148165ae5f429cb908f6651d73f34707603b14238fb0"
    sha256 cellar: :any,                 monterey:       "ee8210810a136f937b068dc92c8889cfb3405b712b3989dbcec23f59954b7265"
    sha256 cellar: :any,                 big_sur:        "bff8438d40327d5fc8420844eb71a95d8e06f58acce3c5b291d0f7b770b7ba49"
    sha256 cellar: :any,                 catalina:       "16a11535c2c6cf526a3ee9cb3520d1f71fedac2a29f943503dd84084ddfcffaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478d1aaf7003eaa9ff49290d35b3275165a3e5427d4825cd6feaf4eefffd5550"
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
