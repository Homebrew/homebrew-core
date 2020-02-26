class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.27.3",
    :revision => "e73882dc0fcedab1ffe789e44ed6254819639ce3",
    :shallow  => false
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "1b3c18e6de21c49d6050d6beaf78a50ebeee9dc5b8e25ce75d54f64ff5a1776a" => :catalina
    sha256 "32dcef3ffe091b3268c719b05e0be5c1abf4532aba9eac6dd5ee54b83ae46c2e" => :mojave
    sha256 "ca56e2654b60f4e91c4157dcaafc49f14bf738b5a0ea54d836903eb8774aa168" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
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
