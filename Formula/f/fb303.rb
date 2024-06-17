class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.06.10.00.tar.gz"
  sha256 "a252e59b9b1d3097506d7b43845422824334b1eddac814c22780b0a9fd03a041"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "136be556ab4a7a5d877da5348b9814d53f51ed5de99366b0eb69eda217a47544"
    sha256 cellar: :any,                 arm64_ventura:  "81147f40ffae65aeae6c95bc058a23ca9c81d57e5d4166ca0644eb05a1449767"
    sha256 cellar: :any,                 arm64_monterey: "4c710a7dc6e5e2bd9988b8340db83ac4ea6c95f0d3f32512c304e23f3d21da62"
    sha256 cellar: :any,                 sonoma:         "552e4c2109bfddbfa6d337a798c4e7b2b3ca693ec11dba60b361548ebb890a09"
    sha256 cellar: :any,                 ventura:        "f44c19d918a9452b5eb3426a5cd1d191103b414b6812dbbc7c4f3946bc19b7f1"
    sha256 cellar: :any,                 monterey:       "0a3ee3effb95dfd60535f51d9f44268eaffcb6f59e7e9608451db909a634e754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d35ff1e3728750ac4859546564ac5861419ec99261eff55b7828bf6aa79880b"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
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
