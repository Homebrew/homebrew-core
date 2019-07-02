class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.22.0.tar.gz"
  sha256 "11ac793c562143d52fd440f6549588712badc79211cdc8c509b183cb69bddad8"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "19afbf59a929a12c6eb48c38da06221203be74665468ec62f42dc99b9a212666" => :mojave
    sha256 "997f008de7fba2754c8d70cc362f35af5b05dbae1f0690aa5a7189a2a714b339" => :high_sierra
    sha256 "d6802e0f87ecb46728979b7642a2dfbd74bc36cf21f1c93d482f83a31d804d88" => :sierra
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
