class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.7.2.tar.gz"
  sha256 "0343496a3e79d5fb7ea7be5fa466d8e00ef0ad459394047b1a874100fd605711"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "8f75587d5080aad30464e6e2e4c101ba944a46e5e8439695bf1c3a1857f7d58b" => :high_sierra
    sha256 "69dcc857c50bfae89c217bd27bb9d08e688f2389413396567e4ff46cb4566f88" => :sierra
    sha256 "71d06af70a82bdbf45f953ef91094131449241120bda3e5cf6c46950b55d79c2" => :el_capitan
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
