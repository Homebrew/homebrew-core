class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.16.00.tar.gz"
  sha256 "01b3c3f2a52e9d32a209a9bbf1f8d960f20f58cd370cad2196c85b6850990889"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a560826673e4b773856ff4fc80f40fb53ba162d20d9fb3c0a966abc9c1d1bf0"
    sha256 cellar: :any,                 arm64_monterey: "087baba00ce5aed063e4456a185281611ed1a33b7457731b7a95689ac91bf0db"
    sha256 cellar: :any,                 arm64_big_sur:  "d4d516cf6373a0a9ab57324a4547ee4a145db852c68df85390924a6f8bd8a508"
    sha256 cellar: :any,                 ventura:        "8d49af3e1f39ca55a45c9ac61d597ed937a0a615521ea2e8cd886dd31df051bc"
    sha256 cellar: :any,                 monterey:       "5b8e3edc9cd35286bab4916f7a25a7a497f0a40365032012ff112d463aef3081"
    sha256 cellar: :any,                 big_sur:        "642bad1ba739e12daee964218711af548cb8d4827f027303dcbb9a349cfa5621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99631d8c5dc062e45898b1add0e1684dd014dad1eb63fcbe1aba65e2941fc2e"
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
