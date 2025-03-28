class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.12.1/apache-brpc-1.12.1-src.tar.gz"
  sha256 "6b315b33ae264e17e4f84bebbd4c3b7c313f5a64de7b398764c68a1dbb4a9e8e"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c86f26c1c38a819ae9875ae8e9c985cc898461826bc6adca275b0cd2074cdaa2"
    sha256 cellar: :any,                 arm64_sonoma:  "a6913c404c189bd9907f5cf38dfe0599bca55fcf3bf27f7493d383b13e28e166"
    sha256 cellar: :any,                 arm64_ventura: "10938cab9c5c7dbc3b4ba444546ac0afc70ec2ddd0bf764c6a544a9cc8a51501"
    sha256 cellar: :any,                 sonoma:        "933b746de19593b12e478e0b22de6fc99dc4ebb44b93720af8d2e033676b600b"
    sha256 cellar: :any,                 ventura:       "8b4af33b95c69d36cdb59c377ee5fd9642133efc74b5bbe1c5a290f7c4593258"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49563320f5d47eb394dd41fada916724e072402727186632a79a759913d7a52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1520d89eae11d459791a62b4e2ea0864523e3cc08bc349666bda81faf31cc025"
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

  # `GFLAGS_NS` build patch, upstream pr ref, https://github.com/apache/brpc/pull/2878
  patch do
    url "https://github.com/apache/brpc/commit/cf6b81f9f7ab31626e942c2ef1b56432a242d1a1.patch?full_index=1"
    sha256 "12c062d417e32a1810a8b223d5582748c2f3c4521864a2dd74575b4a10c4484d"
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
