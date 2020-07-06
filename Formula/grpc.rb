class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.30.0",
    :revision => "9655f1f6449dca36312489f9c82560c32050af71",
    :shallow  => false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "8f3212ca72a09d11787864d33503116d0527478565f36f666b68b10f6e286173" => :catalina
    sha256 "eb609a63758d89d676d8e41e6f2b4a1d9eef0c5e2aeeffa85dc883728c9c79ae" => :mojave
    sha256 "990d0b3fa57618f5b19d5ea719bbe1817f8fc17e51e05a8709b097e4acdaa18e" => :high_sierra
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
