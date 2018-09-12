class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.14.2.tar.gz"
  sha256 "c747e4d903f7dcf803be53abed4e4efc5d3e96f6c274ed1dfca7a03fa6f4e36b"
  revision 1
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
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "gflags"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
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
