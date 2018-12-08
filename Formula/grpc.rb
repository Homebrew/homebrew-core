class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.17.0.tar.gz"
  sha256 "d98d41399783c8f9f0cd8d8fec3920c8378d3a77ec4b7bdf228832cac4ab8617"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "5f51a8c841a9a152875264e288559aa4ddd6f259fa2ddb89e6ce49639fa723c9" => :mojave
    sha256 "41f45f7338c070e5246eb11a3b17bebef630b0f89393404cd740addc892407dc" => :high_sierra
    sha256 "f08f78ca9559ac2a6432ddbb4341f0928ee160db61315df42ce83512282fb77d" => :sierra
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
