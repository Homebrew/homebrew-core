class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.15.0/apache-brpc-1.15.0-src.tar.gz"
  sha256 "0bc8c2aee810c96e6c77886f828fbfdf32ae353ce997eb46f2772c0088010c35"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f567ec2d226b62ad9c71cb209d8c73732ea18e8060f0cc8b4ae28790e0036c3"
    sha256 cellar: :any, arm64_sequoia: "c31c7b334897927ce901498c0ef0a8c9b0b309c2e24646d3c5cc0423d9b23d91"
    sha256 cellar: :any, arm64_sonoma:  "89be1094ebbb941bafd4f564d9df2db447404fe2f3544d6483d85a334ab071d6"
    sha256 cellar: :any, sonoma:        "f11417e6c3be3b7317e50ec3da35c2622a773b08f4461fb501e2b80135d31d1b"
    sha256               arm64_linux:   "89a2ea7c0c1ac653a05a21526617c0e6e2ab9ccd9f7c2b186b36b843630b81ec"
    sha256               x86_64_linux:  "771c698d51a79bd2e6dbb4555cb5be115b0f802e881a36c7e4d26867f1f96ce2"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@29"

  on_linux do
    depends_on "pkgconf" => :test
  end

  def install
    inreplace "CMakeLists.txt", "/usr/local/opt/openssl",
                                Formula["openssl@3"].opt_prefix

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    protobuf = Formula["protobuf@29"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -lbrpc
      -lprotobuf
    ]
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
