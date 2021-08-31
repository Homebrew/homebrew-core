class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2021.08.30.00/fizz-v2021.08.30.00.tar.gz"
  sha256 "d0473583cb06a5d2e264c0b6dcdd4643b7417c3567be8201392bebf1d4053062"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3c2008b631f98d2089a674804f57cc6cdc62d7a3d7607c3233d6587a49559149"
    sha256 cellar: :any,                 big_sur:       "1c4a97c50b57828bb5d2392ac6c216a76266ee475bfddc2b6d9a2f7dcb683b8d"
    sha256 cellar: :any,                 catalina:      "610c2a0a72bfe1a7196302cf62c20309044d75126e49eef93bc55268285df87d"
    sha256 cellar: :any,                 mojave:        "7e419e3b81003b465bc3fb4179f4f96ac1978857c5999329d117b3e55bf45bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a13c5b0abc68f61ca24ffd7e33de6bd67fd59570d0d255763ec097abaedc93c7"
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
    mkdir "fizz/build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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
