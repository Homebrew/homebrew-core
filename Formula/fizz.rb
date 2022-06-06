class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.06.06.00/fizz-v2022.06.06.00.tar.gz"
  sha256 "67dc74d0b93d9fb1b5c79b1b12e0b7ba4b6df11eb231cdd3a9dd8d0523703b47"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c1eac1a2b9e6ddf6472bf23ebbd09a8c76bf281d7024484980930e183d95fae"
    sha256 cellar: :any,                 arm64_big_sur:  "d0c6dd609270a25b42e9b553d31c4d190f3f1be30bee827e562df4503632bbc7"
    sha256 cellar: :any,                 monterey:       "85b3ca1a857a889dd10b9cb78c494a23549e960c0271f3148c5697bd9826a097"
    sha256 cellar: :any,                 big_sur:        "95da9f48e129059f6464631222784bc1e318e8831ff757fbc2f5986797bc6c7b"
    sha256 cellar: :any,                 catalina:       "e5d274a8ec81ed5293b0b15302bf5ea9fc60b0e50fbdd6ad5c2d1a9b38f84251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc22a2dd158ca2be42ad06c217e3cfbf63aa83702f185788879309df5669940"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
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
