class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "bc5ee6bdd16a181c26c496a4b07604517bbf1453c992303e0bffdb2f5f6d02aa"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c79e54d002616fc1ae312cd4bb267050d1a871c1c6271ba0ac56d71ffd949939"
    sha256 cellar: :any,                 arm64_ventura:  "fda99ab5188790c7870b60c1f14752a1be7bc6468e8d64054742c4256836c56a"
    sha256 cellar: :any,                 arm64_monterey: "1561f1813a47209f06ec6513752a8405d80a2a952d1eb81bd2e77f9ff7c49d4e"
    sha256 cellar: :any,                 sonoma:         "8fb3726487333f97a22d7d8074e741c5fc50b4999fb7c3c3ab4fe133331c8297"
    sha256 cellar: :any,                 ventura:        "d4ec35e094dceb9c1e9babc60442336dc05c6e6e54e35378053fee2a5083fd62"
    sha256 cellar: :any,                 monterey:       "2558c5b0f047687811f130c395369a443a673b81545e180d4245f6c95e212afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689f7aac29516e18abee25ababcc319b9bef3b961652a37e2d95f694450a1c0a"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
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
