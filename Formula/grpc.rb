class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.6.tar.gz"
  sha256 "041e529a0eef5de3d427a61fcba6a46e8450f1e624a0fc9dbe263395ea100e06"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "cabfe05686c03f42822f92ab0ec54210ac5c9f2cda7911db9c42a0eab3f70658" => :sierra
    sha256 "d804267ff0f67da1b9a8fd8003bbb40e86c0c3c9461e68837296593f489eba7f" => :el_capitan
    sha256 "351660a8c2022cef64c90d3a7d4ac72d0ee8c3a40859ff2b21e67f026a3a85d4" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "gflags"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
