class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.13.1.tar.gz"
  sha256 "af0d41b5fab2797a3bd71bfe1b8c94e553b7c7317f87f664de26bafbf75677c4"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "614a3e4328d88928290cc8ce9e89405b18843f3b9be9bc1d9ab126ebdf0c941c" => :high_sierra
    sha256 "edd04139bdb23bd823ee3ba8b29e14eba955ce22f389c0468f14caba296f374e" => :sierra
    sha256 "cad4604da47849ae73bbc49a66f926dbd78a76a45805b67612cc5e7030bc9e20" => :el_capitan
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
