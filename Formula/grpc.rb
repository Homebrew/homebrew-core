class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.12.0.tar.gz"
  sha256 "eb9698f23aeec2c3832601fa3f804e4d9dc28eca3cc560ef466c9ade1ec951db"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "1d25c070c5650c8c52e4e20e0b35b2812f408e8177d8585c6ee5f487658e5e8a" => :high_sierra
    sha256 "1b75d11d8d838ccee8615e8a75b9a63200f17885654a9bc7d7c2897fa6560e50" => :sierra
    sha256 "5bd7e37f0ca2e566f09fed4af6620b52097d663938ce30347e27155a76b1a0be" => :el_capitan
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
