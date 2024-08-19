class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2024.08.12.00/fizz-v2024.08.12.00.tar.gz"
  sha256 "5c83f30d9b3a81e15076047ccd69021ae2701da0fb436dea84bde49f9e3ac413"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb17edea0a2c0a908c1cd30ace03b7ea86767f0385b1e7ba62039c445120a865"
    sha256 cellar: :any,                 arm64_ventura:  "c20b021a112246661c8ca7a393d7e43bc1f8ef1805962bf86ea3c76bf4bf1a64"
    sha256 cellar: :any,                 arm64_monterey: "ec559d04f4653971c60847a34a346bfa1375729afe2218f06942f7e84eb941fe"
    sha256 cellar: :any,                 sonoma:         "12354f81e74d3b98764b2d910235fc3e2c06a6193f02c64d0ce86570dec07b9f"
    sha256 cellar: :any,                 ventura:        "eaa0ec3ad8442f21b1323d5b00d7e5df1ee99dcdd5abd8ed601743501c0317d8"
    sha256 cellar: :any,                 monterey:       "4cab66cf310625fdc4f3898a5e6138215d25c2bdc6319e40c7b89cf38aaf51fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120b72aa9b46f21f5f0c797feb66deed573650e4cc406b58daf02c5435708545"
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
