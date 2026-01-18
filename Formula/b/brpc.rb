class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/brpc.git", branch: "master"

  stable do
    url "https://dlcdn.apache.org/brpc/1.15.0/apache-brpc-1.15.0-src.tar.gz"
    sha256 "0bc8c2aee810c96e6c77886f828fbfdf32ae353ce997eb46f2772c0088010c35"

    # Backport support for Protobuf 30+
    patch do
      url "https://github.com/apache/brpc/commit/8d87814330d9ebbfe5b95774fdb71056fcb3170c.patch?full_index=1"
      sha256 "33a133c583d39a1d8394174c8c5f02b791411036faa3b1afe38841c3e6b2e0f1"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc71a22411322bb443295a8285e7f82056133b45a6f413fca2e770f86cb59173"
    sha256 cellar: :any, arm64_sequoia: "532e7c16f320c0c9867cd40ab4ad1bd37d2ab5b03aef3394fdb2f149f95a1618"
    sha256 cellar: :any, arm64_sonoma:  "f132c4df2fe54b858be3765696b9d30525a7d7d81c59768b979ae3e150c19ba5"
    sha256 cellar: :any, sonoma:        "b2806f2fbbc1f62a2f49c6ce43647eaa7a476b4f98abee4e91d96b927df6ddf8"
    sha256               arm64_linux:   "90b65fb95fdc62ea2c9ea228c315c91233b3641a786bc6b349daa81dc02fbb7a"
    sha256               x86_64_linux:  "43adc9606d0b38e5fe57870615bb307dc081a3aff756731c9e4f0045511b73d3"
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
