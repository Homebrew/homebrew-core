class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.1.2.tar.gz"
  sha256 "373ef66b0919bedef70021ba6798eaefe1cb560a2c94ccd2631d38fc9268f524"
  head "https://github.com/grpc/grpc.git"

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
