class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.1/protobuf-c-1.3.1.tar.gz"
  sha256 "51472d3a191d6d7b425e32b612e477c06f73fe23e07f6a6a839b11808e9d2267"
  revision 1

  bottle do
    cellar :any
    sha256 "091069fd8d0e0ee029eb4b1fe60218a580325b5e9a4185d6d92441bcc5ced531" => :mojave
    sha256 "0eebbb3a3fdbe9446dda2aa384c25c851bd26a40d79803c2c45953e70207e10a" => :high_sierra
    sha256 "5f46c8bda4cf0214396ee8221fb9e0443f3bf8131e4e4e359e282e71288c5042" => :sierra
    sha256 "137df0af212e53d2e640ca57e8d80511a92bfa782f3d851a535afe340422602c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
