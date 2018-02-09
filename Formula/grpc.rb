class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.9.1.tar.gz"
  sha256 "fac236d49fb3e89399b68a5aa944fc69221769bcedd099d47eb6f93e59035c40"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "4146bd47025f2d40545eb58ec959472f9a1f5ec30f3570f5082f18e2e21ffac3" => :high_sierra
    sha256 "396c4aa8458456173baae26289001b4ec166f1dd64f866e237422d6d1f91df09" => :sierra
    sha256 "b95b457c8548eb82cfa5a3ec5bd9e0487dbe3121f66abd7a7ca0e5bce1ce8331" => :el_capitan
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
