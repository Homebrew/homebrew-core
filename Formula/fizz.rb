class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.10.31.00/fizz-v2022.10.31.00.tar.gz"
  sha256 "209b0b3e856cf93df574e859196fcc9ea15bb12aadf7d63b0f449bbbb3e5f985"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "27e501d834c34bbdb1be7ab453bff238ea520f7a9d61769dd8180f9ad22507a5"
    sha256 cellar: :any,                 arm64_big_sur:  "97aa73c37b6719478369df4df995ae12c3a6e8bfad38232c7cac2bbd3a07de98"
    sha256 cellar: :any,                 monterey:       "56f3a2a63affa894e370bf8de51df95fbb4f63c7f660519e63f6b460bf6df405"
    sha256 cellar: :any,                 big_sur:        "1398affe7641ee7210be88338f42d9cd1f3139f930c91f9b4efedfa219e800c2"
    sha256 cellar: :any,                 catalina:       "e7d5697a0e096a8e6de2e87feae97a6d1903d997e19a7b67be8e38c55f8d89be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4076b63564ee23e6d369ae910df4d3e6231a960535309ce4ccdb85bad58c6e8"
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
