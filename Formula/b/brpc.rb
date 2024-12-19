class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  license "Apache-2.0"
  revision 3
  head "https://github.com/apache/brpc.git", branch: "master"

  stable do
    url "https://dlcdn.apache.org/brpc/1.11.0/apache-brpc-1.11.0-src.tar.gz"
    sha256 "7076b564bf3d4e1f9ed248ba7051ae42e9c63340febccea5005efc89d068f339"

    # Backport support for newer protobuf
    patch do
      url "https://github.com/apache/brpc/commit/282776acaf2c894791d2b5d4c294a28cfa2d4138.patch?full_index=1"
      sha256 "ce55b0d5df5b8aaf1c54cd7d80f32c01e8fd35c97f12b864ea6618b38d2db547"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93c8a376a77fd67cbc1d81e86122a654ffdc5557ccb3cedd7a1b7794e66cfd2c"
    sha256 cellar: :any,                 arm64_sonoma:  "6336199b03157b0815e16d5746a8b38cdd1b26315620d1248703e9f47644513e"
    sha256 cellar: :any,                 arm64_ventura: "ebe3932aa02fc721345f5efd52cfc75bab914bf7d32bb5de41ef26ee3d048dcc"
    sha256 cellar: :any,                 sonoma:        "f91d3bcacce553c9267fcc023073aba9e88e96d9bfc615507693590e2bca3685"
    sha256 cellar: :any,                 ventura:       "f4e25d9e0517ede51044cb4c49a347f50f9122421d70549b764b9451e930f00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e5b2f0c9c13d310ee082a88fbb870a7a2f9b5bb54fca0cfc3259ae77368744"
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

  # Apply open PR commit to fix compile with Protobuf 29+.
  # PR ref: https://github.com/apache/brpc/pull/2830
  patch do
    url "https://github.com/apache/brpc/commit/8d1ee6d06ffdf84a33bd083463663ece5fb9e7a9.patch?full_index=1"
    sha256 "9602c9200bd53b58e359cdf408775c21584ce613404097f6f3832f4df3bcba9c"
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
