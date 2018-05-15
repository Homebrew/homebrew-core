class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.11.1.tar.gz"
  sha256 "0068a0b11795ac89ba8f5cc7332cd8cd2870a2ee0016126f014ce0bc3004e590"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "7808dce9c2b3c01fb7fa675d6880abfbba3a493c707f901c0843de06e3c53b81" => :high_sierra
    sha256 "00d8e895e2fbfdb0dba6c89f591984d91ad0d77312482efd5cd0d1d5d140e76c" => :sierra
    sha256 "bd84b5dca2ddb73532e5ec72515fad27d274af44af7686e19244c2d5ed577c81" => :el_capitan
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
