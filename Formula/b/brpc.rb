class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.9.0/apache-brpc-1.9.0-src.tar.gz"
  sha256 "2ed6090845cf9f36bd267de7f151970881340ad775eeba65aec448db47fa25b9"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "247d6bf51d3ec6b518eb5a16b8cacc9317632d6aa372c0e701d710a230ee4600"
    sha256 cellar: :any,                 arm64_ventura:  "1da49dbe63d077c5ac9d40d27d1090d3c124cf8f149e42b523e9d68fb6fa7bf1"
    sha256 cellar: :any,                 arm64_monterey: "8f58bfea674a387f3396fd4a3b4b4b2e7cccef845e2cb7ebd4315f6d19baab70"
    sha256 cellar: :any,                 sonoma:         "4cc82ac052e3510b72973368dbaac87d74113bf5327d389423cad5c64ef93821"
    sha256 cellar: :any,                 ventura:        "9e70411141f630972996c893ed65768bbaf28e9c2fa9c2f5863aa9f67caa2919"
    sha256 cellar: :any,                 monterey:       "afc9e82b8e7d11ffe0ec178810fbb64ae3918c0afcc0a622ccfda9084f2b24cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0c6a2ff650f8ac797b665e4a257019428ddf7eb11a7b2e7cde5e4aa829915e"
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
