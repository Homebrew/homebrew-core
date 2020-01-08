class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.26.0.tar.gz"
  sha256 "2fcb7f1ab160d6fd3aaade64520be3e5446fc4c6fa7ba6581afdc4e26094bd81"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c4f5de2b38f129f859c67eaa6c1b1b0dfa9420a1ba09002a02028c02d9ebb114" => :catalina
    sha256 "8978cd949cd6a1043aa7266eb4524b199581d1cda3c8ef1f82208dba3bdf894b" => :mojave
    sha256 "01778edd57f6f09df820caf0e3955d2d27f224bb2188d60de622e6288cd6f40c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
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
