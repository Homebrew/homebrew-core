class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.15.0.tar.gz"
  sha256 "013cc34f3c51c0f87e059a12ea203087a7a15dca2e453295345e1d02e2b9634b"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "182eab0c18adf7a29af57f92ea8b6d83e12b32489557019a1887cd2d06da757d" => :mojave
    sha256 "0b0caa4134fe25924b12b4d173630d30325b6a0ecbdf9b3eadf48ab160d34030" => :high_sierra
    sha256 "86ac835592405f621cff9af0b61a41f073aad2bc2eb288eb285c66639c933357" => :sierra
    sha256 "1fd35911ffd0f9ac7c8d5fef5b54e0715aa65c86c7ec4ded5ca42e8b0d9339ee" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl"
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
