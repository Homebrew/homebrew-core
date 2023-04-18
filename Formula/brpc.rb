class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.4.0/apache-brpc-1.4.0-src.tar.gz"
  sha256 "6bdfe4fae5103edd4216a5893bc75d97707697bd559bc7a48513b3474e702009"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e264a100aed4c80986028a2d97179dd97c852b9c6e36b99d59baaca4a5e8d0e0"
    sha256 cellar: :any,                 arm64_monterey: "475d34c1b280151d195d7c3473bf20ca9986f42046a9bc1344b1b00970e562dd"
    sha256 cellar: :any,                 arm64_big_sur:  "bce0061b7496584cb07b299879e4c212e4a244f6f55864dcc00efc795982bc20"
    sha256 cellar: :any,                 ventura:        "34953c707f9e6b532478a87063ee875b31b433a06b945b60c4152bc82e55a1a9"
    sha256 cellar: :any,                 monterey:       "510f88fc936cc9c452afe03f5c5f6428171a3cdd267417f40a8d2221db302438"
    sha256 cellar: :any,                 big_sur:        "6be898d218bfe45cde43d01a1c06e88558711b006fcf6da6708bac160f6f1ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135bf4550a5698ee60bdc63fc23adb56ad57184e6a94e3f95be14a8385953abf"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      #include <brpc/channel.h>
      #include <brpc/controller.h>
      #include <butil/logging.h>

      int main() {
        brpc::Channel channel;
        brpc::ChannelOptions options;
        options.protocol = "http";
        options.timeout_ms = 1000;
        if (channel.Init("https://brew.sh/", &options) != 0) {
          LOG(ERROR) << "Failed to initialize channel";
          return 1;
        }
        brpc::Controller cntl;
        cntl.http_request().uri() = "https://brew.sh/";
        channel.CallMethod(nullptr, &cntl, nullptr, nullptr, nullptr);
        if (cntl.Failed()) {
          LOG(ERROR) << cntl.ErrorText();
          return 1;
        }
        std::cout << cntl.http_response().status_code();
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["protobuf"].opt_lib}
      -lbrpc
      -lprotobuf
    ]
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
