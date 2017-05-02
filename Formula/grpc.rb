class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc.git",
      :tag => "v1.3.0",
      :revision => "3ef2355eaedc07f8900ad98d079448169a2a2a06"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "9b631827c846eb392cf7f9fcc957f7f94fea4055c23162407d4c69e0afc9ad86" => :sierra
    sha256 "b4f390bf8ac5fe18cdbb6206a587c76840e4bba0a4046283554b937898241e44" => :el_capitan
    sha256 "15d66faeeda7aef74b8ddbd59f8f93c5971948a4eaf9efe020fe6cd798455d06" => :yosemite
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
