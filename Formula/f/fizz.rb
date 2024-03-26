class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.03.25.00/fizz-v2024.03.25.00.tar.gz"
  sha256 "fcd879c0471de3de24e6e01b4029055de9b4d93aea5994afa31cfd3900759bd6"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f25577bf349518fcb231daa7cdf733c02bcc4946e5b4770a57563cc0a9fc24af"
    sha256 cellar: :any,                 arm64_ventura:  "811a6f24b096f9f7668a2fef89110f831eef81347883a7c74ae109438354f600"
    sha256 cellar: :any,                 arm64_monterey: "2c259f4832c10bea01569399d6da6027e9d5cdb0a3fe418906be682f97de6d5b"
    sha256 cellar: :any,                 sonoma:         "800bb4dc7a39b6ad702dad0b2e52ea6e850d8e56dd88a9d3d4f672d6d5a99e95"
    sha256 cellar: :any,                 ventura:        "e73b9725bbd55f173906a638297ff6c1115d7f5c8b8fb1b3d6c2f113ca46f7d0"
    sha256 cellar: :any,                 monterey:       "81c874f6ab308dfeca167861b84d2b9a1027c10c23028c11c2aa42c8b51571c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac7a129ca95967ae16eb84220cd4c12dfb0afc0921ad2d4334074c076bd54c6"
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
