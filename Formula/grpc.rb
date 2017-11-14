class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.7.2.tar.gz"
  sha256 "0343496a3e79d5fb7ea7be5fa466d8e00ef0ad459394047b1a874100fd605711"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "99861c580d4e289544f638eadce925db4e7282bf37df2cb0fc12c7ae70e83f2b" => :high_sierra
    sha256 "2a9f6f2c175869a29ca0bdec17f6509b48665745fd1470c87bf10760ce3b7345" => :sierra
    sha256 "b3ebb29f4de7cc57eacbd6f1e39038899b8f58fe86f7b6f646f25a40a649afb3" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
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
