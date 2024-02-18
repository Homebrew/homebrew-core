class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.05.02.00.tar.gz"
  sha256 "82a5d9a6af95bc708e9adfc7559fe2cb5f605103516f9b183d1a7e1e1a83ef89"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f73dbfc3f55db3e25a6597d9f6dc63b69c1e01affe42843845ce25ddcab620a5"
    sha256 cellar: :any,                 arm64_ventura:  "5ab6b2e557c1376b6c907ccbd50853a0849ce7da3d2b4d7e4218d31e48eb411f"
    sha256 cellar: :any,                 arm64_monterey: "cb99c3737cd971446d9049c1189756be3c6b773eea5363752ae706402a906509"
    sha256 cellar: :any,                 sonoma:         "d1f2c684d48bb93619cfd4d7c8c4316b09a41e0893e1169cb10183be7d9d919d"
    sha256 cellar: :any,                 ventura:        "a6cc3f88a65c08f0bff165cdd2fd8ba2f3218fac59066ffd6ffcac2d11ef7964"
    sha256 cellar: :any,                 monterey:       "ed1c848021beb7caf5c56116b280e878815076d8f0e07b3a9bec286c1a032768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7064bf7ca43e1b24f63eca6e3dcbda15af326bd11a5cab58d3c6d96a7a1ec44"
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
