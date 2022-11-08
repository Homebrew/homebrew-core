class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.11.07.00.tar.gz"
  sha256 "0cbe04edb1a077c38e684dd3084e1a39753a9c685baaa33c5bd660d871ae13b9"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96e41197fb5b6dd62ed25461180f195b4b3fbd731552f1520cb7354067cdefee"
    sha256 cellar: :any,                 arm64_monterey: "be0b05a052acaeb7c0ad6031df634514423d642bae1d12941c2255da85440d82"
    sha256 cellar: :any,                 arm64_big_sur:  "e2f5e9713124513fa415b0f7703cc1a0789f44b2a7c70542e28ce843e6d3690e"
    sha256 cellar: :any,                 monterey:       "a5b45423fafeb24f8c0d57776297d53cf1f6fb37212a4204c1789682753bb8b6"
    sha256 cellar: :any,                 big_sur:        "5a51b956ec337de1dd58905471f6e93c850745ea5e48b1132ced51dab12aa192"
    sha256 cellar: :any,                 catalina:       "f4d26c903433bae2de508186f9998f7311734eec484051862b5f4769162a6042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35fbbd2deb8689c8267523595d473ccf7060e93827f9df914ff3ba7217ed2858"
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
