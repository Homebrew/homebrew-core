class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.16.0/apache-brpc-1.16.0-src.tar.gz"
  sha256 "4d5e84048e12512c008d24e52c9e0baa876b5f3f9b06f0aead38b55ea248fdc3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "edf689ceb1b7f6f51524c95670c84475387d516a95b6f4862b332a0dfbf5344f"
    sha256 cellar: :any, arm64_sequoia: "3a91db6a1c4b66e334a744dd2aa1150baf9e464e3595cdea0db8621695cb4588"
    sha256 cellar: :any, arm64_sonoma:  "44961ac6282d2640b5c3d05d3e3e098b44cd785073420d9f821d68c83aa734c7"
    sha256 cellar: :any, sonoma:        "591046cf78fbda05a35c75f084fd3ef2d2fef316bfd0731940e953af06c91a39"
    sha256               arm64_linux:   "472bf124484071423230ee2f6d1b483164033331cfa40c5a71c3506ef65ad2f2"
    sha256               x86_64_linux:  "8791f03b3104246637a4742e6a2f16f8d55f7740d1414b96772913e1dda25045"
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
