class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.9.1.tar.gz"
  sha256 "fac236d49fb3e89399b68a5aa944fc69221769bcedd099d47eb6f93e59035c40"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "baacaa17e506055ac25da956cf61c86b442757434e35e4f8ef14a945d5008d57" => :high_sierra
    sha256 "7dee2cb72e6de6b015092f50febff6bf55ee06f4c416939903c1e8eef8290567" => :sierra
    sha256 "ad39dc6251dd75ee91c751dda21d765ae60301b1940990c72821b0c474060d70" => :el_capitan
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
