class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.6.tar.gz"
  sha256 "b97eaa0c8a63b0492dc94bdad621795b4815278e841f06b0c78d6bcbd4c8bdec"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c2a8981612a1f8017860dec664eb350a0b2c8c29daf06b8f1c624381dc7e46d7" => :high_sierra
    sha256 "d517bee8e0aaf5f66f6453ac76f4b56bd455d96f9338150030ffee48e113e657" => :sierra
    sha256 "ab1d28008d90b8ff1e802b3dff4b9fef904dfe7a9197c556fd6e9cdd3785cb43" => :el_capitan
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
