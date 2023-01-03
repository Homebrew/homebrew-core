class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.02.00.tar.gz"
  sha256 "260cdac75d109ef042f6de145082f7b80d367b9947c2eb4f09446568efab9564"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c1abffa56ef4a29872c192b01090fea9758268051bf18367577b305aa4d3943"
    sha256 cellar: :any,                 arm64_monterey: "c379bc98acb6e24b54427fd90869c7549fe0266c7c74ee0c8f21d1ff7bd4ea6d"
    sha256 cellar: :any,                 arm64_big_sur:  "9dc6c25de659f38a473a160163f9aa767cce05bf2a21c7e0a088bc292b321524"
    sha256 cellar: :any,                 ventura:        "d091d36ca2176025b01014398c7b011e5e5dc11eba2306888ebd5688648fc617"
    sha256 cellar: :any,                 monterey:       "f6d4bd2b0fb5aaf0197b8320833badc52c53bbd0edd8a0216a75b3e20ed0e6aa"
    sha256 cellar: :any,                 big_sur:        "8c241a9081e58d9b3b96650d89f26eb2c0550e67edf4bc9ed17d6559cd6215a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622b0819e5fe7f97e25d7a2750314fead46ee9dd86ff02340a36e41f4a190188"
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
