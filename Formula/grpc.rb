class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.2.3.tar.gz"
  sha256 "e07ac5a2c657c25d5628529ec051f2ae3fa69a1d8802125810cba0c35fed9adf"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "e9d79a4d05cbf8cfea58207529cb5f08b8d3d2e3fc329162f2f1f7b6d610349b" => :sierra
    sha256 "dd2b3de34a0ce71f9ae437cf8a88ed739d496bb52659ed924540af49727286c1" => :el_capitan
    sha256 "e94cc5b04a4a87826cf113e1349224a32784a2c4a05241622fff04366a4e3623" => :yosemite
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
