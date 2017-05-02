class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc.git",
      :tag => "v1.3.0",
      :revision => "3ef2355eaedc07f8900ad98d079448169a2a2a06"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "3b7630de883c30a634de609a8e18174495938063c9f283c592594b5383038a6a" => :sierra
    sha256 "cf4fac038132dddd1a6ec540f5700ae5af1118c64516967a93a8c20e9efa2d7f" => :el_capitan
    sha256 "ac081476150951359751312baff462bd844b04f5852f0edb2698c54b86adaf8b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
