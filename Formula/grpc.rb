class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.1.tar.gz"
  sha256 "ae34c8255ea0aa4f893b9b2cb9f02d8e13bd9d7f2a90d1c39d56a5d6143a9f44"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c78847cc8430daf15a9905719c1e1718ba42978e7412349900ed89b4dd87edc6" => :high_sierra
    sha256 "bb5507e1f5801a9ebd7a8f00043e4e829ebca3a9717b5f39e43d7f0e7b5f6338" => :sierra
    sha256 "178ca8ba2b2761ba3de97ac1374036f805802825aa86af94d7b69bafdb257f5f" => :el_capitan
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
