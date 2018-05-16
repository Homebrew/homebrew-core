class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.12.0.tar.gz"
  sha256 "eb9698f23aeec2c3832601fa3f804e4d9dc28eca3cc560ef466c9ade1ec951db"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "0726dfc86c947290b1c8d1d6517685eb9a8589e4d7e0a920fdcc27e9a1260fa5" => :high_sierra
    sha256 "32cd54b8ca91858ce9154fcfeed1443e7486eed0ef9780df611ef05ccaf14d13" => :sierra
    sha256 "55ce59b11a5eb812ba34ca259cbfe133ea0e458dee6797ac73975e4527e47f14" => :el_capitan
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
