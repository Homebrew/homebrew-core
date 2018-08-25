class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.14.1.tar.gz"
  sha256 "16f22430210abf92e06626a5a116e114591075e5854ac78f1be8564171658b70"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "16a61aa304757dc72f172d8771c86ce1992d0c4df7c215ef9404b76c0bc19f7c" => :mojave
    sha256 "e1466a0ffb702f2ba76e03875701ed7ec88624f55497b5de47f5727cfc2dfa1e" => :high_sierra
    sha256 "ca43a0fdc5e5f4265300cef6f9b1e70449a529a2d050d5e49f53e1852af2d311" => :sierra
    sha256 "2520997527906e3e7f74463d6c6a5cd80db5cad9e4dc840b53ae73cad158b629" => :el_capitan
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
