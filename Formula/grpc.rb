class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.19.0.tar.gz"
  sha256 "1d54cd95ed276c42c276e0a3df8ab33ee41968b73af14023c03a19db48f82e73"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "f10a63d499e31fafef32ba2ffa3028b8533b9d294c77fd9f22916e929d32ef8b" => :mojave
    sha256 "97699ed8034acf2e9f8372516ba1a684e6d280fd909c0835b0b6c251df1b5fcb" => :high_sierra
    sha256 "a7bb32ebdb2c9ec465232946ab333a27e55bc3ad395bc62e72eaeff87623152b" => :sierra
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
