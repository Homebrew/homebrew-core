class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.0.tar.gz"
  sha256 "f0143c99942f47986713a92fca43b2fe8441e46f30caea32c9430f31600a9808"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "299f61a8ec68bb37ef5479fc8b2e1edb64484b3105afcd9174b1af8f1e64de48" => :sierra
    sha256 "2fa0d4a30e7c1ea711f4bfa7a86306a83dcf1da19136131b4dc39521db372b32" => :el_capitan
    sha256 "3445dabb86dd87e6f987a33cb982342d2d6e3d294c910e400fd742939c1f7a53" => :yosemite
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
