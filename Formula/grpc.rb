class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.2.tar.gz"
  sha256 "ad58a5004242a865108f60f6348e677a1ffc8f99dd60e35d6a6cb6d809ae0769"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "ebf2e533fc2dab3251df1ea324d60f89b28c754a7e48695d044682e44eaa5eda" => :high_sierra
    sha256 "634c9071f77ade49ec0cfbf8d736907bf25ea00699ac67011eae6e8c8957001b" => :sierra
    sha256 "21fe8fceeaa690c7536d81a567d51e797517c37302603628318a43fab7fc044e" => :el_capitan
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
