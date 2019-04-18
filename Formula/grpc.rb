class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.20.0.tar.gz"
  sha256 "01c5e617d098a33672ddb640d0e50831fb7c613999435e5dcf115021abde6b9a"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "3dbcbee0d61f1f7ababa75137aea6d3807948e9277b28af08f54c5103af36b3e" => :mojave
    sha256 "c84b7c44f27aa32d7f99c9c179fd975d840b70a51ebf68c5c4bfe0602dd63705" => :high_sierra
    sha256 "99559ac0785f83f2abe6e9cef11eb23c79e7f80c6edcd743d316e319d400c029" => :sierra
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
