class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.2.tar.gz"
  sha256 "ad58a5004242a865108f60f6348e677a1ffc8f99dd60e35d6a6cb6d809ae0769"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "027746d3feca6bd77020e5ce092b5e54d4578f423321ab080d052ca94935c17b" => :high_sierra
    sha256 "3281acd87592c73d8c5884b61ee57e1cc267540f1b097311c6ffb8ede7db429c" => :sierra
    sha256 "67658bb0cfc8f93ecd9d44cc03a6066578efde8de72272e5baf616cdc5b5bb18" => :el_capitan
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
