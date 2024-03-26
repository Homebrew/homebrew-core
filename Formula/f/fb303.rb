class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "25f410148fb9eb5423d43f39f4c16168dec76b998695c84e465519c39ee7df05"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "90205da1a3793882b1c31b1766f10b65533aca0955217e3150b139604d1795d7"
    sha256 cellar: :any,                 arm64_ventura:  "72777e122c6f61c6de0a6edda9dfb3437b58dfa73b1148509a08d75000badba8"
    sha256 cellar: :any,                 arm64_monterey: "65adac97c8233793983037c482d023df9c4c89611a091ea5643e32c309e8c192"
    sha256 cellar: :any,                 sonoma:         "d5082dd4c4781c8ca30f9ed1dbef6f0688edbda41fb6159446c94ce1b5a57622"
    sha256 cellar: :any,                 ventura:        "468a117032a8c816592da37da8fc3ccf153d8966d9ff6918f1c419c9802cfb72"
    sha256 cellar: :any,                 monterey:       "980644abbca77e8d78f97e8256bf3c7ded4a48c2427473b8a14c8d561a7e09a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a27e84b1fca2dd96422106bee8f9dc0881cecb103d6eecce9e7a0290143c66d"
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
