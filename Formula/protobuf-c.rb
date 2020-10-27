class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"
  license "BSD-2-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "65e5c068f791400af318be3833c85214b93100760bdb20d9c72dab1ffd9b253e" => :catalina
    sha256 "7974584d3adf082d581c6de928ae1cf5941299c62c84fa3d30d38754f70932e2" => :mojave
    sha256 "204fdc925724863f69bc6140bc06dabf16f63c8f9ef980cc70fec9340928012d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

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
