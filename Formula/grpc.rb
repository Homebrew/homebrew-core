class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.1.tar.gz"
  sha256 "3af9172a7c4322e98c5defc0c4d98c72cf11b9334d904fefea0ebef5ae0ac952"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "615141ba3567fc67674906262124bb75291f5523c7cd9bed28d32da117cc8c95" => :high_sierra
    sha256 "3f755d899233110621fc3aaec6c260ee8d423336b042297886afc0b144eaa52d" => :sierra
    sha256 "1e1ff7a199a2472b03226d4954840e954f6d85c018a7f7ceef9c8ad89e1bad99" => :el_capitan
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
