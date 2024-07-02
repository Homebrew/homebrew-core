class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.07.01.00/fizz-v2024.07.01.00.tar.gz"
  sha256 "b09992d81865a7418d4bf8be55b1a1833223757d48818c421019f696e1fb4a71"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2e129abbce603219471b64f8d17103ad322f6291979f47122412ece70bcf12d"
    sha256 cellar: :any,                 arm64_ventura:  "51a1ecfd25cc1dc5e8b4fabd3f6a295842d85d91040958babf8875adac982de5"
    sha256 cellar: :any,                 arm64_monterey: "c9a3a3d702ff7388eac566d29bccbdbf21e1963372af2152b57f45cc579e71bb"
    sha256 cellar: :any,                 sonoma:         "42d036c26cbb74ba7454666821852e6e6f2dd98e0b1cfd64f624c9af73f43ac2"
    sha256 cellar: :any,                 ventura:        "2ed1def0a0dd8ddf07773f1e33d07bf14b4f7ea02bd46e5d347fc86b862fb175"
    sha256 cellar: :any,                 monterey:       "fb847db9a4f8cf0b456b2136f25fc14c0512d6836482311e89d0744daa574a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e503eeb22a64e17a0e5dd794292af3dcb78365cf86fa4e0f638cd7b3aec2ee"
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
