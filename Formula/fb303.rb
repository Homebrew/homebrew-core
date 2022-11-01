class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.31.00.tar.gz"
  sha256 "ee41ea55ffc5a4b84f80d10a966c60e2c668b6e8c75a53a20610f9bd43f416f4"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05b8e440efda5982049a3c1d9aa8ee680acf8130bef28e3c5107f97eb693022f"
    sha256 cellar: :any,                 arm64_big_sur:  "5b849302dffc659f24686febad8469c1d095bbbbdd974a4ba4e8da496fd3b942"
    sha256 cellar: :any,                 monterey:       "4c3a801faa0e1a4006e2b4600b660b6fa967cdf6260f4d7deff334ae0e6d8284"
    sha256 cellar: :any,                 big_sur:        "5e5a8cb037504f8e5a6cf1392ba6930cbf1251a7b474d90eada548ce0bc618b7"
    sha256 cellar: :any,                 catalina:       "fac723b804479e69ec5fdf4265c39cd3aa2b870c635103783a543c2f29530179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0013fee93029c482505ab1501d020ff7194853a8f56e62c826c5dcb5ce4e215"
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
