class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.5.tar.gz"
  sha256 "df9168da760fd2ee970c74c9d1b63377e0024be248deaa844e784d0df47599de"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "5f16296bc076672769d3db5fb8ef1758d8d036c172c07a765f7cfde34405767f" => :high_sierra
    sha256 "510d69ad6ec7b3550fcbc0d17078042db4b4473268789972531287dc835d3d68" => :sierra
    sha256 "8cf604aa28a8d02572647b6070a10f0c06d46e431e90291c7e20a3cd211ce536" => :el_capitan
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
