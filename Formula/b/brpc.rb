class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.17.0/apache-brpc-1.17.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.17.0/apache-brpc-1.17.0-src.tar.gz"
  sha256 "30fc544c74ef51419d262d279571c2c1b5db7dda1bc3bad893b1397d676fd02a"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "daca5a0d5b1e3b3ee96394ad5301777b87451677b56c17803009b0bcb5db2cd0"
    sha256 cellar: :any, arm64_sequoia: "5d9242419a240381ac02894d91e6a03153f929f61e08056a7ae0f8523053b254"
    sha256 cellar: :any, arm64_sonoma:  "653469081290fca0db0ef3f37000000f6f382d5c02e7d8c9a88cb7452367a7d1"
    sha256 cellar: :any, sonoma:        "c9c2af8f8336c18d2df385f961a2695262d2d7b7e3332941f98874747e9f246c"
    sha256               arm64_linux:   "b33cd126ad8db5eb35efbd8fe43ec1db492cd7bc8abc716fa77a997721ffcb5d"
    sha256               x86_64_linux:  "43287073c0dcc4e94e63f346e2023399fc735d529b8e995e2bda312260651223"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@33"

  on_linux do
    depends_on "pkgconf" => :test
  end

  # Guard the Linux-only SO_BINDTODEVICE socket option, which is missing from the macOS 14 SDK
  # PR ref: https://github.com/apache/brpc/pull/3320
  patch do
    url "https://github.com/apache/brpc/commit/d7fb5e33bc3b39a349eef619d7d6cacd623abf4c.patch?full_index=1"
    sha256 "0d7d064dd77360995c643cc7e10b9bc42b04f5cccf33992160288e654e588098"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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

    protobuf = Formula["protobuf@33"]
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

    system ENV.cxx, "-std=gnu++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
