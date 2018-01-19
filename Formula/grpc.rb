class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.5.tar.gz"
  sha256 "df9168da760fd2ee970c74c9d1b63377e0024be248deaa844e784d0df47599de"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "97e429e97bf6a7913a78564c60f1bcaeb5e01195243a9dff965b95229045dd89" => :high_sierra
    sha256 "90ca950b8d7dbcc0e5cfe5d5ca45ec7a9763b1e6ea6065c39786a0ca54b4bd52" => :sierra
    sha256 "3931d76e703824ca6097f3b74498b648298e7a90c3ce4bcab33faf6db1f9e3a4" => :el_capitan
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
