class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.09.22.00.tar.gz"
  sha256 "a98c30ea070ef111b83973fa74b6319907eeebe0888187037375857da97256ba"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d9ffa4366a259432dfc1fc17f9e26e3b6a3aa616a47426529c88c924818d2937"
    sha256                               arm64_sequoia: "36d2966bd415917a02737d6b9ae4537fb5d865c103fa60885df87006d4cdc841"
    sha256                               arm64_sonoma:  "8744de0d7a9cb9ec345d6e14c30045d45c80231777a782919b0e5542e655fd3a"
    sha256 cellar: :any,                 sonoma:        "db095dba5404ac62b27a8c669cbf100252cd3180d1bba0895fdf31eede92a9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca715d7d5ee3a481ee9053b927d0754ba3038346eb1d9f612562148cb95753f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5613ded4cb1fadf9f105770a4f3d56778b90bd70d91007de50c55473480ceac"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++20"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
