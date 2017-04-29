class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.2.5.tar.gz"
  sha256 "44b60a7d2d6108ee569f970373401b57486146bc980bf4dd8187ed052e95cb83"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "f7900121197e9ed105bf1f98dafc4c15b275ad6a2800ccd0d8071d9ad6467439" => :sierra
    sha256 "e1b501777dbc3ad130160f8ea3b6161d2c8d78a17a5418e519c83a19d1919327" => :el_capitan
    sha256 "73501e9a46f1109dde195f1e1a2e909cb8004611fb714030af75b1a93c2d6519" => :yosemite
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
