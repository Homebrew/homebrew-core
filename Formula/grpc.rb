class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.3.2.tar.gz"
  sha256 "6228fb43e6b11b1dec5aa21e66482bb45013b45cb70c1ca062f4848469d1ab99"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "e0ccd0df50601f0751f83d9c61e6be0f17d4fef2c975150124933024e0c66e93" => :sierra
    sha256 "a71fff80505c44b12df78be8bc93abf7d67f2a8750135859952540c83bdbfceb" => :el_capitan
    sha256 "383c032f152aac18760ec2ff65863f2e5caff41f2eb8920f2c607852e0ff6e13" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "openssl"
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
