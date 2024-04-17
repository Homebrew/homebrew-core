class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.04.15.00/fizz-v2024.04.15.00.tar.gz"
  sha256 "7d419f45766e0a1a78d9af1164977039be392363b88ac13f7b1f3f22506a0240"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7c11da0484d30f8ff833284f62ea4f063bb13b8d716f93758794a82fe634e95"
    sha256 cellar: :any,                 arm64_ventura:  "a1211a69481457011fdd8a8f4d080f89d916b46fd4730f0086a2db06ea4e7da9"
    sha256 cellar: :any,                 arm64_monterey: "08f7da78729cc97dc3492cb2cededa6a808bc9e337f1a7a53081850e85841aec"
    sha256 cellar: :any,                 sonoma:         "61e273a82232a0629c8f5458da426f91415d0140f7178b08d95170366aa07ba9"
    sha256 cellar: :any,                 ventura:        "1a5b585855369b2f069d3128fe4fd7a768b2a19f27b63f079d82de9e579f6f3f"
    sha256 cellar: :any,                 monterey:       "e0aa73ee9b7f2b03cb559a421fea76d18fc20987a7d5119ad71088d2cbc22bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8faa05f13593fe442df9bd139582b854d2062e8007bb0aa3cae24df12b0410d"
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
  depends_on "openssl@3"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
