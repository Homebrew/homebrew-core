class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.4.tar.gz"
  sha256 "fc678678f34fc6069c7aacbaa20e067529246ce3145f3b54ecddfcc876a27b8c"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c272cc87521a599a9fd8ea89c2798620453ffbbcef1e8e844c6ba7fdae77b7f7" => :sierra
    sha256 "02b1475e9ecb5ce76974eda4f059f3c6a61229dddbf2f6a634985dcdabf51801" => :el_capitan
    sha256 "410da244619e82ecdb4cc807074efad71847978fad53eb3857867e5a5ff16659" => :yosemite
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
