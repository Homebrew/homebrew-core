class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.3.0/apache-brpc-1.3.0-incubating-src.tar.gz"
  sha256 "582287922f5c8fe7649f820a39f64e1c61c3fdda827c7b393ad3ec2df5b4f9d7"
  license "Apache-2.0"
  head "https://github.com/apache/incubator-brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "382a6deb2c15f11562ac69ca645b9c361d94caf2346bf182dce1f2a54a9bb870"
    sha256 cellar: :any,                 arm64_monterey: "34b3794cbedecd1c80925c91f79f6f69ba6efb408165a5c189d4de7783430c6b"
    sha256 cellar: :any,                 arm64_big_sur:  "886117566d5c45c6de1da0ac4eabf3b5651073766f1a1ff76b56047848c5a4a5"
    sha256 cellar: :any,                 monterey:       "98842f35e57c39112ebb8dbb3499217267afa69949ff85aecf7ab08fcb3bbbe0"
    sha256 cellar: :any,                 big_sur:        "1430053d5df145f7fd5816f801d1fca38f41834cfd151451048452a52e0a9e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4279dd6133c90689487b330c51f7508d65088d032dd9d5621b77625aeb7432f0"
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
