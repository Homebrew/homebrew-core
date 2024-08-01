class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.07.15.00/fizz-v2024.07.15.00.tar.gz"
  sha256 "e9887a409d6a1b8c42f3c52f48a06f62373b0f6de8586a4497d17634808e9931"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "752da57cf3499bb56751b5314483c1c1ad39fb7bae7c9fad5480cdb14dc13ae4"
    sha256 cellar: :any,                 arm64_ventura:  "09188560ee718156359fd5524da63d7fe7db2f51ebce59e96626296665de99d5"
    sha256 cellar: :any,                 arm64_monterey: "693d73f0e8daca9a4cb5823c2624d602c7bfcccb967d2c85824066a5b3adc919"
    sha256 cellar: :any,                 sonoma:         "1599023165e63d7b45a9635058c1e8a7bf237e003f6c3d4032b658ac1dc9edc0"
    sha256 cellar: :any,                 ventura:        "2106ebb2412e112621ff6aa48b2de0338acdb4879dc048b2a1000372a8c93d28"
    sha256 cellar: :any,                 monterey:       "53230a2b79ac694968839e8ea6cce56cfdcc1d07eb3cc1e8312e336d6397948c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3cbe88cdc72062b11ddfcaf580b060a0d2e590ca8f2645de26d8a33c620ea6"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
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
