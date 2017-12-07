class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.7.3.tar.gz"
  sha256 "e31107f5ee6970525a2b48dd6392613a32d7eeb69c6151cde8f64272c179c866"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "94741958930424bdc2f8d3ea2b2cc3a7d8b369d6e6462664efcd4def25266192" => :high_sierra
    sha256 "239e7336ab3142f2a59eab6062696e045b60176a9a7ceec5a6c63b72e87329a4" => :sierra
    sha256 "83be73bc7189f079132b99be292f92f40e0c8a9070c8d52dcb7474cc0af12c4c" => :el_capitan
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
