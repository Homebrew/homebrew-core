class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.6.0/apache-brpc-1.6.0-src.tar.gz"
  sha256 "06ff4adebc720bf1529b03ade872cbd41c6ed69971e6e0d210d57d7b72856bd4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "416efe5f9ad82c73e8e014765b9a86013602d12614093a616a7fe65a9b6b4ab3"
    sha256 cellar: :any,                 arm64_monterey: "7d548498fe23338a9b037bb7acb16737435ae5ad4f33de8f1044ab91dfb8d9dc"
    sha256 cellar: :any,                 arm64_big_sur:  "67a025037aa2fabd36b5a4aec29c022a3ec7fff9a47e90152a0ba27e3619d786"
    sha256 cellar: :any,                 ventura:        "1cc8d7c34068d97ee7d5aca3fb6d7174cc563c7b66b80a35b17b1fcbd358736b"
    sha256 cellar: :any,                 monterey:       "e08fdd6ae58eb71138754e7e4ebdd594bac9b7a9572e0c7e071024340d539e68"
    sha256 cellar: :any,                 big_sur:        "eaff28b5d66368f73e6d559e8e6af03c9ffafe1c6ce5b0fcaac5775a755df6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e57115da4a1f549c4f5d919754cf5693536fd199c30d1747f6b5059032477f"
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
