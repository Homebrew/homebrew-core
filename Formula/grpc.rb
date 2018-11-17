class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.16.1.tar.gz"
  sha256 "a5342629fe1b689eceb3be4d4f167b04c70a84b9d61cf8b555e968bc500bdb5a"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "63dddd0d91fc00e08130a1247e42e7cd55a146b108931fe00e4b2da404797e65" => :mojave
    sha256 "a0e0f3bbc1f85dc903ff325d89a59b2362db098cb2fdd0d32e55b4004aab1d56" => :high_sierra
    sha256 "29f03e0d40ee6dd3fdcd40c4507013066f3452fdb0da5224892c46f691ea4dca" => :sierra
    sha256 "fd35affc1687cfe8d250d0aca1715a9000b25d97705a40912c84a699293f330a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
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
