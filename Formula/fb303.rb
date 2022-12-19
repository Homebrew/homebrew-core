class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.12.19.00.tar.gz"
  sha256 "c4c0af3c9f498fde59b9d819067adedd3190e23559beacbca9033f9787a3d32f"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d526448dc3c8ed484dec02292eb95de549f34384e282332754e28d44bdca402b"
    sha256 cellar: :any,                 arm64_monterey: "02296776d46dfc73d644695ca1d1d6a6fd86082659903a7b56e150520c234680"
    sha256 cellar: :any,                 arm64_big_sur:  "ec0d0798933ecd911b43acb517d31b352d5ce8885966add94e8df681a2ae1f23"
    sha256 cellar: :any,                 ventura:        "c00f7934c15998991a104d467c44927ad579cf1f7abfb2ed19a025781d9d9462"
    sha256 cellar: :any,                 monterey:       "56a3004c767aba0f8d239b0546069e721f6de15a2a6f90625a0e52f1ff5d981d"
    sha256 cellar: :any,                 big_sur:        "092a6376a54d2050a0773eabefdb4d071a7ed0c0f93a58c032959f57b288cfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506334a37498b86b2ea9041d9f9c91dfe3633225716aeae0756b9cd64a095ed5"
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
