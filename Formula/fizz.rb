class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.02.01.00/fizz-v2021.02.01.00.tar.gz"
  sha256 "edf156d28318f030b64b75b0d1a50da1344e6bbfe0c59ba161263d7e287fc682"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "677144f69b781d421a294fd292628dc317da9990819b0dff7434fa268c56cf76"
    sha256 cellar: :any, big_sur:       "005d0ccb179f7d687d4a936b92a06a65cb24974e62891920dd1f953137e15ee2"
    sha256 cellar: :any, catalina:      "3ef5055b3d5381a7423bef29faa4de26fa12d620e4a3dfaa6bf61be37c9ca779"
    sha256 cellar: :any, mojave:        "fbe197790e479a134d450952b1059f90c02fe354e52461c5fb5ebe923b04d061"
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

  def install
    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make"
      system "make", "install"
    end
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
