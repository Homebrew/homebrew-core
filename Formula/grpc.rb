class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.3.4.tar.gz"
  sha256 "c12ca2693a3b3d80cadb15f1618d9ca6c83fe8c64a32b058a95ff8dce39b3e82"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "63b2bdb6d2bf1a7115cb4e4c91725d052ab19e65274e688234cdce59334eca1c" => :sierra
    sha256 "f03f71840f9684feca66be17e8e469c65bfe780d81fa9b5a55449da553db914c" => :el_capitan
    sha256 "9f521e15c7875264377142d24da78df5bafb0a836866b554ba96f7db7c0fc729" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
