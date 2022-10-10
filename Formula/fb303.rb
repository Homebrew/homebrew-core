class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.10.00.tar.gz"
  sha256 "afd2ea8f3a3e8d38d5fea5a27381441307aca2486686aedaf65022946c1de3f7"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6af60b0abc923064c3c790dec567ca2303461cc6c6f30d45499d803ce12f8cc2"
    sha256 cellar: :any,                 arm64_big_sur:  "3e9213ca677150d1e5edc985726e404827e10a4c3b5f400fa0983753b500ea87"
    sha256 cellar: :any,                 monterey:       "ade782f9844e6f1a96a5a8bec6f582b6aaae0a39b01bbdd3e53c0e0b021d1a88"
    sha256 cellar: :any,                 big_sur:        "181ea9f7caf728fb4348de36c6c4a99c89243e9844c7e95552fe692e154b968f"
    sha256 cellar: :any,                 catalina:       "d27ef11880c4c600f597f3f71057dccac9fdba8affaad05ec2928588a1564459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea4b033153b9708526485c244700b5ab7838759ac61864885724ea98098c6f0"
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
