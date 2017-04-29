class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.2.5.tar.gz"
  sha256 "44b60a7d2d6108ee569f970373401b57486146bc980bf4dd8187ed052e95cb83"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "fd69337c190ee3d4b5558d4385fa19f0225a3f1f825d85edfa0d2370afe07281" => :sierra
    sha256 "0da1c11cd53c9d0f55c84f517a5157882e0788c6175100d13cd2b31685794b66" => :el_capitan
    sha256 "9a2fc6fe4e4f6d37188ead38006bdb97a97f8a6c7ab14f2e670e532ad24fecef" => :yosemite
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
