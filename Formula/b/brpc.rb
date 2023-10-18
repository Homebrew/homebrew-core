class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.6.1/apache-brpc-1.6.1-src.tar.gz"
  sha256 "7bea77e2f28d33480bf2c6dfe171077e0b51d5d56fcc5d7a1dd7cc5702620e4c"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0694f50284159f02ea36fa531b8e6aec9aa0405395f71b7446b01d341289a31c"
    sha256 cellar: :any,                 arm64_monterey: "75ef2dea505e6346555de1072c9a4097d2083db9e132f288c2019eb79c3442d3"
    sha256 cellar: :any,                 ventura:        "9da00fce05ce3d5bed17ba53e7b7d31a82682b15548258c6ba3ebfa5e821b0e6"
    sha256 cellar: :any,                 monterey:       "b897f1411027a4abcc69cf7e8d536c00136b20e377046c756c7e202d267d64e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e5c646dab222a86bde6e4a14e3cd8c8314a968cb05255af113afe8a6faaffb"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf@21"

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
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
