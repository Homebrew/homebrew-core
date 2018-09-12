class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.14.2.tar.gz"
  sha256 "c747e4d903f7dcf803be53abed4e4efc5d3e96f6c274ed1dfca7a03fa6f4e36b"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "ef9e30c5846caed3feba477a3bd5fb94e0358a7404de359e73852df2236062d4" => :mojave
    sha256 "4c7534357c3fdbb85b699337e34a0c1a281399e02a3cc2cde4e4109668bc8f5b" => :high_sierra
    sha256 "2c25ee4a0ffed05d6eab69eace34d086420ac6aebc069e92145eb7b901d5dde6" => :sierra
    sha256 "846e041d263475fbf6dd855e61871409f4c9a6730cd858dc7621ca88ffa04e8b" => :el_capitan
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
