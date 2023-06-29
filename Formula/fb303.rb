class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.06.26.00.tar.gz"
  sha256 "416103e9e4188c84e1d47fe65d79e2ab5fdc56df908c6b0e12803389871518a9"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea5ea865b746a1664553acd0f88922618c6f5031db0a7379e75485588e5b2bc8"
    sha256 cellar: :any,                 arm64_monterey: "8e6071bbaf97d7cb0932b20946f5dcd3d0a506c4600083b8e5622d081d8628a7"
    sha256 cellar: :any,                 arm64_big_sur:  "07e54796e4b76f99d3bb5a207d863cff8986521091137b2764ed23d6a760ea1f"
    sha256 cellar: :any,                 ventura:        "f3285885ee9e0999ba71fc21a6eb84649e80b51e5f08d34ad732997c6db2090b"
    sha256 cellar: :any,                 monterey:       "937ddf9969a1acb60c6eeefdc36ef7d3ef6c93b8e13b4685c1138b8107dc6b81"
    sha256 cellar: :any,                 big_sur:        "a814a01c76590698ea64a56e5e07969bbc3ebb7c8cf5160c399c9dd874a3a4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee82d9767d6732ee0b65b8a83f67b353fcc000185707e48d68b61bc09414752"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
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
