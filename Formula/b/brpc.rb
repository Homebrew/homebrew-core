class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.14.1/apache-brpc-1.14.1-src.tar.gz"
  sha256 "ed6e6703122cf294462ffae921c713910594b3b0a26dcfef5357a3dcefcc43d3"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "907180a60425188a23acc0a5d93784ba4047890dad76053ba69252951b78b0ae"
    sha256 cellar: :any, arm64_sequoia: "b8307576b1d30d75adc93078ad401a0e5f3742122af08b35841a2b684db88034"
    sha256 cellar: :any, arm64_sonoma:  "be4797e5ef97d0fbbb5e3f4fa8c27a9505eef89b02a6dd900a914d29eecbcda7"
    sha256 cellar: :any, arm64_ventura: "eca6d54d5f87b57105abbf5ba1501cd419caeccb8b49795b878468a31f4499bc"
    sha256 cellar: :any, sonoma:        "840e1df043630eff9372151308b2e8dc5664e17c636dab49fb3bc74672b3651e"
    sha256 cellar: :any, ventura:       "772ee453731d366000562ca62206c4681fbbad5682f7e7142ed5fcf7674c20e2"
    sha256               arm64_linux:   "ebccc42348d8674b3f3dd035f634e5e35a3af44564c4c523b36ac5523bf927c0"
    sha256               x86_64_linux:  "ea97cc02bbc5ed0506323cb56be35b773d5adda0d91c5bad1dc11cd50de7aa1b"
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
