class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.20.1.tar.gz"
  sha256 "ba8b08a697b66e14af35da07753583cf32ff3d14dcd768f91b1bbe2e6c07c349"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c6d0cb215f3e47e7c18c4b028a7ad59518387bba827f963753a13436c70f2d9e" => :mojave
    sha256 "4f824bdd5a5ee5d568f14401a2c50073664b3aceecb9247d2d3baa8d4260c8da" => :high_sierra
    sha256 "d842f161e2f4076cae4492e900ad828d0b41e1fe5bf8a57bffbfe3d19ffa791d" => :sierra
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
