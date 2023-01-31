class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.30.00.tar.gz"
  sha256 "e11ec912767a5bcd76fce60860db7886ee2cd4dcb13df424e3618b3f80351fc1"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f22129c62da3a85757692b1b8dfb2148fe6c6801e4400fccb4f4dc1f4e19b0c"
    sha256 cellar: :any,                 arm64_monterey: "1d8c60ce7d3d1376bf0b0e589d7949d26a170f9895661fe5db0e25233a99f34d"
    sha256 cellar: :any,                 arm64_big_sur:  "c4489e1247e8bf8cb5a443bf57fbf4b475a6f2a2347142437009f1452f50f3f9"
    sha256 cellar: :any,                 ventura:        "1f166d7fe8be47d68773643f2903517d0201ab060daa6cb8db1faaef235026e0"
    sha256 cellar: :any,                 monterey:       "961235df0d6c8fc5df52ac41658852486b1fecbb0505d2adf123ce8ed491b232"
    sha256 cellar: :any,                 big_sur:        "4aefaadfdb61f57b44b83745c640589b8f6eb7226925fb09943fe3aebbd826fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4bfd6d78525f907f6f9e5b2a1b64e242a6e74f5c9c39bef4b633bdc9cb3be4"
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
