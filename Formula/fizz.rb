class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.03.00/fizz-v2022.10.03.00.tar.gz"
  sha256 "92e8487ad54e27c106a8db2f5f08f1b66b1bfc5a17398d08daf4af3e690dbebd"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf0edb8800fc99be298ad0e62a37c521b999a57d445606f9cc1325cd26ce58cf"
    sha256 cellar: :any,                 arm64_big_sur:  "dee4f97c8c4bc5b993cdc9e262419468469fe2a30e724523d4840cfb94a4a9eb"
    sha256 cellar: :any,                 monterey:       "0ee48d8d38f8495d3535053de3fe6a8d3eab49753a36b55ce803a6d7f3416e0c"
    sha256 cellar: :any,                 big_sur:        "b6372dbc74de9ba4e1828aa900ce7c62ba069d52b342e24e1d23ca0a40a94df4"
    sha256 cellar: :any,                 catalina:       "7a7513b968f6f14afdaf9c54a5a54c3464d26b3d8026a1bd33315da22136d858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fc2e7f4eef0dbd13f57bbee0c69a74627e327568bf3b913eee6850c2d8ef41"
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
