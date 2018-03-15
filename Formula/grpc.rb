class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.10.0.tar.gz"
  sha256 "39a73de6fa2a03bdb9c43c89a4283e09880833b3c1976ef3ce3edf45c8cacf72"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "7556915e3f01d983f1b5137d33a4b3fa61dc41325ca221351aaa759a97da4017" => :high_sierra
    sha256 "525181740a14942b0aae738c0f39dde8f8f34c3dff2125818291013c7ebdf8ae" => :sierra
    sha256 "d1f33e9d348170ba25bb2c5a22b680dedc999971f58bed4e3b7d578c67637270" => :el_capitan
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
