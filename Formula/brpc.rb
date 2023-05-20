class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://dlcdn.apache.org/brpc/1.5.0/apache-brpc-1.5.0-src.tar.gz"
  sha256 "8afa1367d0c0ddb471decc8660ab7bdbfd45a027f7dfb6d18303990954f70105"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00fe5c27d0397666f3d0138a0fad86edb9208a5581180b267a446c084fccf01f"
    sha256 cellar: :any,                 arm64_monterey: "5575f56fe530af83fd95ede301598bb876c3e1e5902ccb091f61d0f8ae7b2f71"
    sha256 cellar: :any,                 arm64_big_sur:  "47938b0cb1fa818fe8c50148c0098379d5c5becc5e833cf1a5738a36c3642b63"
    sha256 cellar: :any,                 ventura:        "c9e41524b326940f8033de8b3945713b43cb20ac56f12d6934e7d1fc231e16ec"
    sha256 cellar: :any,                 monterey:       "73c668678e7a6d1779edec5ab0806a1b3e6fe82c0929225c2243091a139df0bc"
    sha256 cellar: :any,                 big_sur:        "fa99288bacf30a725ff3289cc53959b3a9e56e325f2bb5171e82858810c60d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7cd87ea0fea8043f1b8d792e03cbb10f17b46d055155570c77e7d3edfe35ee1"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@3"
  depends_on "protobuf"

  def install
    # Keep C++ standard in sync with abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD 17"
    args = %w[
      -DCMAKE_CXX_STANDARD=17
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
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["protobuf"].opt_lib}
      -lbrpc
      -lprotobuf
    ]
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end
