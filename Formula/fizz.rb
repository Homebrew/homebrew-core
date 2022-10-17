class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.17.00/fizz-v2022.10.17.00.tar.gz"
  sha256 "6c7069cb6812e9ed990b65e60c4d87b59d59c4a11f26d0ae1e35498e47489d9d"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73eb73cab6fb559ea0b1fe0b098d8f848597fc7cb7f4baa4a8994989c5772389"
    sha256 cellar: :any,                 arm64_big_sur:  "13b8496d6d0961d9b7c474cfe5a3c88aacc0eda9ff5ce8287c713f5cf71bf9e0"
    sha256 cellar: :any,                 monterey:       "d540e056b81e14ec73b673955af78471537771427a6e13a194f1514a60698673"
    sha256 cellar: :any,                 big_sur:        "6fd36d2ad153772f7e6cc8f4dbedfdea2d78eeae741ef5f878d9fbc3191b30ad"
    sha256 cellar: :any,                 catalina:       "7f8be335cff120452536e874cffa0bb95a108401347bc04dafd066fa70470d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c8ba5248b52e4bc124a85866348a24fa9d8d1f981718079b79b53ebe2e7688"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
