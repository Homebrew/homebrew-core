class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  sha256 "4d5e84048e12512c008d24e52c9e0baa876b5f3f9b06f0aead38b55ea248fdc3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9f749085a9ffc7bdbc37df38a1026a5c633aacd51972da257caa744ef06635b6"
    sha256 cellar: :any, arm64_sequoia: "a0cf0ef8d126ffea67d0366cfbb0d039987b2a54c0872271e24a6231153fdd65"
    sha256 cellar: :any, arm64_sonoma:  "e28fc3fbcd68781d861023b747078f09cbb9e4b968f8ef4b389459d2575b28ad"
    sha256 cellar: :any, sonoma:        "766c971326938d129d6ead09bd4fdacdad6e55c6816a5935b9467d55be843ded"
    sha256               arm64_linux:   "c9e0a00bc92e3cd7cb8a0a60de88ef65757627646baa4b1a2510e181a2453ce9"
    sha256               x86_64_linux:  "17a192f07db661c8dde442fe7a87f18bf28f6fb340ab6ea29178c28159f88c4d"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

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

    protobuf = Formula["protobuf"]
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
