class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.12.1/apache-brpc-1.12.1-src.tar.gz"
  sha256 "6b315b33ae264e17e4f84bebbd4c3b7c313f5a64de7b398764c68a1dbb4a9e8e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df58cedaa897dd10c04705d1848044f888e61e8ec91be4f53d3baabe3cb68205"
    sha256 cellar: :any,                 arm64_sonoma:  "7f25540edd6cb683afbfb7f5bd8b2691cb99b7ebe44884318e883fc563704a2b"
    sha256 cellar: :any,                 arm64_ventura: "e01414f778fb7f10e9f6eef1018d80604d474c7107155e24c4c2544be7db76ac"
    sha256 cellar: :any,                 sonoma:        "424a6f1bf623b331a7e994f01e4e7aa9c428b932006844d6267556baa64e1ac2"
    sha256 cellar: :any,                 ventura:       "58d7a787321608a32799cd063242ad728d5ca64289652e51173385c0b53085ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86170b8a2df17d343f671bd837046eab5320bb859f29925c3519e698a1f452d5"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

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

    protobuf = Formula["protobuf"]
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
