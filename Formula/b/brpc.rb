class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.12.0/apache-brpc-1.12.0-src.tar.gz"
  sha256 "8318865a3178221580a075731e2a76254efd1428e0153a8147d8a74926ce8dfa"
  license "Apache-2.0"
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbc997ce16192c1b81a0cb76f7593d66421c7e068ea2400bd6f1486567790a81"
    sha256 cellar: :any,                 arm64_sonoma:  "ea029355c16445006dd91896b32d9fc2ebc4c8cdffcb7370847a0cfaabc50185"
    sha256 cellar: :any,                 arm64_ventura: "f85e7760459b9ca973da450747ec22812e6436fc810132af465ae679026637e3"
    sha256 cellar: :any,                 sonoma:        "fbcc762a81a1e3041a11aa2db995ed73674be8b8bfa63a98c5b2d0fdcc84bc37"
    sha256 cellar: :any,                 ventura:       "491ed31eda4bf7b967a506a15407ea72bd764a354bae51d9cb7c743d01f06919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937da6edebc8e3afb57f5a3bc3189c04e15ec0ccdfb81582d0a0295f17722bea"
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
