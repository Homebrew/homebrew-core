class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.4.tar.gz"
  sha256 "9da621f79f6369f674d6e4091d4e3a4ec8a62ca2a4ab6d9152081934a10aa271"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "a18a9841cc5e14c482818f157dd1185db9b00331a22efe0ff491ea1e4f6cb1dd" => :high_sierra
    sha256 "fdb19c0bef85b44d2518c3525e4f9d459fd9013ac934191160a5dcfe946ec62f" => :sierra
    sha256 "db0cb295543590cc7f9a01ec122ba59f54255dcb577078e4dbb8b7b009f88a0c" => :el_capitan
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
