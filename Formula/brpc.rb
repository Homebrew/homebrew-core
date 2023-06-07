class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://dlcdn.apache.org/brpc/1.5.0/apache-brpc-1.5.0-src.tar.gz"
  sha256 "8afa1367d0c0ddb471decc8660ab7bdbfd45a027f7dfb6d18303990954f70105"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c075c56a2de92f802881875fea1734d63719f491f925ca9623e3d75b99293b2"
    sha256 cellar: :any,                 arm64_monterey: "2e72aa583dc38d463318c54318800ab334e4d8880720c9f8835461e96a9bcced"
    sha256 cellar: :any,                 arm64_big_sur:  "77d272b5f9f6601bbd9ef7489fc374dec749345beae026ca9216a850d99f1a85"
    sha256 cellar: :any,                 ventura:        "7dcc503d9307030e9c1c2bc57b4a361fc018b22a13fbb1d002a935dab6e66f96"
    sha256 cellar: :any,                 monterey:       "f3dffdcfb518f908ab18d95921bec72fcc4897d569d315c273b3e5fef4777b26"
    sha256 cellar: :any,                 big_sur:        "20f3c293101cc84726a8cd7770e8bf8138207e10d68675af63377aef62b62d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c6a6661ec461a171a2590a98d7062f0b029a5a91dac68672c36884a3234674"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@21"

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
    protobuf = Formula["protobuf@21"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -lbrpc
      -lprotobuf
    ]
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
