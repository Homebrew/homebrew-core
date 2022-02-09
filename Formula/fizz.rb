class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.02.07.00/fizz-v2022.02.07.00.tar.gz"
  sha256 "59faf6e0c74cabe270f9face13e0a9aa3b1c6b6abb15bdedabc8fd21afcdfbab"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30393267b63c670db2a3250956b637347c7639afc150f0a588fc3460bd4ed996"
    sha256 cellar: :any,                 arm64_big_sur:  "2ddcdeff8c6f7baeb3993ed308a4d91c311511e4ef7f9d515b80cc8d4828f425"
    sha256 cellar: :any,                 monterey:       "e36ebc129348ee873ef7786d5c1bf6b1d51dae2d9fb8a42f7e72a5ee294090a2"
    sha256 cellar: :any,                 big_sur:        "2689d82a0ceffb751adc7501014117b39fb5a0faa1b89721f8e4ff0d12b7be66"
    sha256 cellar: :any,                 catalina:       "404acbd6f9a9b5d1afaf2e0dbbe8033065fde0131b77c61b7ee803a44e308c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b72021d2d8eeb07ce4298fe08038c344585be48a244b23ca4196bd4e5bae8e5"
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
