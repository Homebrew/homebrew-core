class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.6.tar.gz"
  sha256 "2a525fa5b0d6486a00f85cf65bb3da60ed25f7cb865628f54b7657d1fd1a8802"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "e680af77c2bfe36ceb9f682b9eefb7b1deaa28dc8c88b2206f9a804208005e24" => :high_sierra
    sha256 "7c17b436165ed24192e6b198be2e3fbc676a73062a7543648ef120d51a9e2a4a" => :sierra
    sha256 "ea785c5344453f623f022b6a1384087377374058712d6988dc717473fb8312db" => :el_capitan
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
