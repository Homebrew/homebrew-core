class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.14.1/apache-brpc-1.14.1-src.tar.gz"
  sha256 "ed6e6703122cf294462ffae921c713910594b3b0a26dcfef5357a3dcefcc43d3"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1881335e1492e94206728d267640c86e734d7533ff429e5a8d0a1244030711ba"
    sha256 cellar: :any,                 arm64_sonoma:  "d3076cb66fc48397a8b0f870b9fd2e1db9be9f9800ee6b1315e773f616e92185"
    sha256 cellar: :any,                 arm64_ventura: "1a49f81c0510b2554ac996982b89abedb2d431ea8bde8fa3a5d70ae0ff632c66"
    sha256 cellar: :any,                 sonoma:        "8800b926c072f4d0004a28f6ad0d53889a72dc47e81c3f1ebb0b8cb9900551e8"
    sha256 cellar: :any,                 ventura:       "3ee00325836873399a3652025532490e84cae6bfffb3c40bb3b435e49e81a1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c809cd315a094bf41409dbe492ad69ab5bab1ab7a4240ccd59451054d95fdadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be97e6df3ced7de50a46902e9784e1b680ff9aab38fc50d9eedda1f68b2ce18c"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@29"

  on_linux do
    depends_on "pkgconf" => :test
  end

  def install
    inreplace "CMakeLists.txt", "/usr/local/opt/openssl",
                                Formula["openssl@3"].opt_prefix

    # `leveldb` links with `tcmalloc`, so should `brpc` and its dependents.
    # Fixes: src/tcmalloc.cc:300] Attempt to free invalid pointer 0x143e0d610
    inreplace "CMakeLists.txt", "-DNO_TCMALLOC", ""
    tcmalloc_ldflags = "-L#{Formula["gperftools"].opt_lib} -ltcmalloc"
    ENV.append "LDFLAGS", tcmalloc_ldflags
    inreplace "cmake/brpc.pc.in", /^Libs:(.*)$/, "Libs:\\1 #{tcmalloc_ldflags}"

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
    gperftools = Formula["gperftools"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -L#{gperftools.opt_lib}
      -lbrpc
      -lprotobuf
      -ltcmalloc
    ]
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split if OS.linux?

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
