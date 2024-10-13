class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.10.0/apache-brpc-1.10.0-src.tar.gz"
  sha256 "4bcfa0ae09b69790c9767c098512e62a0c2c1d896a38559415a92e5d1206965b"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d6d546991106ec10996d64ff95b58c01c61267afbf9bc9cd7377a88bde9b9ddd"
    sha256 cellar: :any,                 arm64_sonoma:   "a4f42713b545c6bdf393661b1c33e855c56f791cc2175f93e6ac968328b21963"
    sha256 cellar: :any,                 arm64_ventura:  "710cc3a18cc3aa0d7294275c887b4d947e8bb661c4b3c0c67bf4190c3918cfa3"
    sha256 cellar: :any,                 arm64_monterey: "b1b93405ed8b571d90dc48cddbaed021561337f9b0576f0f8e5e5ab0bff4031e"
    sha256 cellar: :any,                 sonoma:         "ea0abdfed6e3ba6bc3f0d0a94aeb9b5e4a46b828a2c0c4f18e05d511e379a0b8"
    sha256 cellar: :any,                 ventura:        "af89289ed5ceb5157cc9b40fd83db742fe98b28d8b9db3670f22a6f9dcbee5e4"
    sha256 cellar: :any,                 monterey:       "8ea78cb0d65f63595ee2669c0ba5f7eb2f1d8d2c0a00d6b91e67a5823d0f7624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdadab0418095e110d55ef0f482c39a094591b348bc167a260ddd277f773fd2d"
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
