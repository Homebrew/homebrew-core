class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.09.26.00.tar.gz"
  sha256 "587a068fa72d771bacb7c3f00f84d3292208d96b65cfcdd24775aa45f254628b"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cb3de089318745897eaae36700664d638724c450d7cfe1ebf913abe1096ae20a"
    sha256 cellar: :any,                 arm64_big_sur:  "37d5261cabcce3e28e009635d2c44fe0dd25d61687a5d74b8f2174d7e254b549"
    sha256 cellar: :any,                 monterey:       "7b649d2b35806fbb8b352ccc782e9d5924c4cb98ccea45893bc2c163180f504b"
    sha256 cellar: :any,                 big_sur:        "d1f2b6007f69e8e46bdc7de450b3ac75e507d819a7b5a83c12edd3a7dba42c83"
    sha256 cellar: :any,                 catalina:       "112a682b4685fb373903f946fe8aee5d50ae7f7a6837372cbba77588b42e7706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f41896249f3502a2f3c4b2dcf26d5549e0e24c874aaebc2e4b85e8dc7db4adf"
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
