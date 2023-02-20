class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.02.20.00.tar.gz"
  sha256 "2e0c39a6fa1156cc8d2d79278a39e9150a7e76e045971c72086fc9c548e26c08"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c538eba5da39ad307588d384765d28d95465595608df7b0d4582a11aa37899f"
    sha256 cellar: :any,                 arm64_monterey: "5e5cd76977970fc0a31c1435e490f3f9ac45603233c4423315f838313ad24ce1"
    sha256 cellar: :any,                 arm64_big_sur:  "6cdc8cc75b339e41672a9a465f7551643da576f064a3c5ba183b2406f5ef2c43"
    sha256 cellar: :any,                 ventura:        "f481632a9838669172135bd192392dabc25a0986dc29a84126b302af5821c156"
    sha256 cellar: :any,                 monterey:       "6a1634b73ce230d227acbc18787a59ba623760f941b7f0e1ce9745348f958d73"
    sha256 cellar: :any,                 big_sur:        "7f9f7ff6f5e6122358e153839a5623244aa2c7588e6365893c156f03f6ab771a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d57d8f6ba7b33c20bc4f02d73efa44e21d4e4add947d721a67b7825fddd970"
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
