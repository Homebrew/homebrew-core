class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.2.0.tar.gz"
  sha256 "aaadb5888f5371d1f463b7bfa8500817935e1531e8a9f376791fdf3f596332c6"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "215f948eeb163c2433dd5f6eb1f515ce24a3bbadb6733b55a3543d2f7690fdda" => :sierra
    sha256 "864c3bad5654081949a9d2cdaf24c5540c51d74580e4d3437660bfbfd0e5b5b6" => :el_capitan
    sha256 "227b03c8774945b83a622f721ba12d1d7d8298533646dd76949956a764eec7c0" => :yosemite
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
