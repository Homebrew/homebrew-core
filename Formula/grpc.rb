class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.21.0.tar.gz"
  sha256 "8da7f32cc8978010d2060d740362748441b81a34e5425e108596d3fcd63a97f2"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "d4e4c229d8c370874fab6dbb997b4789df86cae027ed05dcf6efb0fa35a5bcdd" => :mojave
    sha256 "b300a25f1f63ff0b12b695299b0d993ab2f20bc532471a91aff80258b923de5c" => :high_sierra
    sha256 "7dadef0f1bba3d558ae507b3a07bfacc6004c0b55e880e385aba93bfc2a5ace8" => :sierra
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
