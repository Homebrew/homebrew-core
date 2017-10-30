class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  head "https://github.com/grpc/grpc.git"

  stable do
    url "https://github.com/grpc/grpc/archive/v1.6.7.tar.gz"
    sha256 "0ed08e406eb3ecb1ab88b1eb183c7c51a996dae8fa79a0e6fbb9561c9098bf96"

    # Fix "error: use of undeclared identifier 'INT_MAX'"
    # Upstream PR from 12 Sep 2017 "Fix headers on flow control"
    # See https://github.com/grpc/grpc/pull/12525
    patch do
      url "https://github.com/grpc/grpc/commit/b2f490c565e.patch?full_index=1"
      sha256 "47e44873afd5a157d7ff1527b5cdb0f08f236589a33de616d2d6d2690a5bc6b2"
    end
  end

  bottle do
    sha256 "6a5c18584c79c72376a976dac256558f6f4217c9ce852aac53d46342581db575" => :high_sierra
    sha256 "cdee88720146ca4854126adf19981c8f53fde2286103327f71702e2b7fab64a6" => :sierra
    sha256 "22f0bb317c166c5bb076debbec4b78560b869051fff07daa7a25e28e93d6cc95" => :el_capitan
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
