class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/incubator/brpc/1.3.0/apache-brpc-1.3.0-incubating-src.tar.gz"
  sha256 "582287922f5c8fe7649f820a39f64e1c61c3fdda827c7b393ad3ec2df5b4f9d7"
  license "Apache-2.0"
  head "https://github.com/apache/incubator-brpc.git", branch: "master"

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
