class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  sha256 "4d5e84048e12512c008d24e52c9e0baa876b5f3f9b06f0aead38b55ea248fdc3"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebabc283ea8e626a983d4cf1c48dd32ffae3c081deb39573ef0ce375961f49ce"
    sha256 cellar: :any, arm64_sequoia: "f3702240ec477b32fe005e5ed1028c882eb9247fe33f64b17aaebf20632fdec0"
    sha256 cellar: :any, arm64_sonoma:  "8a5f179fdc117860db24efc3c5b36d5556b781d8ef5c3e4f47065b4fdf61ca17"
    sha256 cellar: :any, sonoma:        "c6efc1a0eee458b2e01fcfe4d05d6ce62286c2790bcfa289c4d9ea54eb3158c7"
    sha256               arm64_linux:   "6adb8de5e2c4af0845231c9e4360960fb26f29912279dab9c0f45482bd3f0177"
    sha256               x86_64_linux:  "6cad6081a79ede06ffe2442a5d449bdbc823d0ca9c55b099803ec4774d6e0e06"
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

  # Apply open PR to support Protobuf 34
  # PR ref: https://github.com/apache/brpc/pull/3241
  patch do
    url "https://github.com/apache/brpc/commit/09b50d2c144e20e687c53829c89138caa7f1f31c.patch?full_index=1"
    sha256 "85536080d6ef84b446c7a3277dd0a6b8ac9672366bde8709abb4e592dc5f61b5"
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

    system ENV.cxx, "-std=gnu++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
