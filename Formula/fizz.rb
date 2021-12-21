class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.12.20.00/fizz-v2021.12.20.00.tar.gz"
  sha256 "355d94957082ab4a8e7d7fa37518065517850926cfdabbb3dfd582dcfd39232f"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "602eec03ab9f0775102f614a1fc7d070fe204869a63fbe6d81cbb7c81d0a930b"
    sha256 cellar: :any,                 arm64_big_sur:  "fb612d77ac2229dacc9db384b05847b1da5d306a98c9e99edb964cee8058479f"
    sha256 cellar: :any,                 monterey:       "2417ae9ea105df2150a23905aad9dfc6453b789b9599c7af9db0f86c815c78e5"
    sha256 cellar: :any,                 big_sur:        "124d5669bac5b9df4a02d3380a6c0456803bf246c44ff92fe0a74588f2d4c528"
    sha256 cellar: :any,                 catalina:       "f06147e6155c990420c97c6077443d4ab30f9165fd01523fdbb3e78ddaf8a517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ec86f63fbe6377b89d2b2912f115709a57e817ef6b79daf2263d4376564988"
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
