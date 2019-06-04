class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.21.3.tar.gz"
  sha256 "50747c8939c535b1059f19534de263eb9b7570b5347390fb24b0bbce8763e9a4"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "a8a543635f3857f03782256d6e1f0ca2c940cb1374e6162f54e01fca084ae1e8" => :mojave
    sha256 "f09eeb400dfb1d2aea5ec5a3a49484f99e3977e476990ec9aaaf4b21459ad94f" => :high_sierra
    sha256 "20b11a31336935bed35f1f11f9b0ee74fe564ed71b9a92118638208cae855a1b" => :sierra
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
