class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.11.29.00/fizz-v2021.11.29.00.tar.gz"
  sha256 "e35805298f612efa99c713400e363ac128660b62f9ef91d836f541a6631243e9"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f06a0fd3da775befe9fe86bf7d96a4f382b4ab5c3d1c3426e6b8a1dfc8da97f"
    sha256 cellar: :any,                 arm64_big_sur:  "50050e4e163d58c34e42ed6560edbe8e27500c5119af2dd3375d16965c451841"
    sha256 cellar: :any,                 monterey:       "69c7c2e6a34d7e43031677546b9f8b897605933e5c872e0d1fa3a560c6451d62"
    sha256 cellar: :any,                 big_sur:        "17780758574c40d94f04b8424d1f258d137b4a7eba60055e2826e4581851aade"
    sha256 cellar: :any,                 catalina:       "a5161be48de185596db44a36f8d6def3287d90522696b4d22f541868c648e42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0ec67cfa3364ae71164de93e3b96d5af7a078350d19b430c31ad5cffe83e67e"
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

    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, *args
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
