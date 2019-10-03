class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.2/protobuf-c-1.3.2.tar.gz"
  sha256 "53f251f14c597bdb087aecf0b63630f434d73f5a10fc1ac545073597535b9e74"
  revision 2

  bottle do
    cellar :any
    sha256 "210b3c49da1becbbdfd76f235e520e376f7648232f3923cff3f705ce5e251735" => :mojave
    sha256 "7c77f4b4a4fe0ccc8a735516965ea26a21aa661b515a0c8fccbe40c3144bf414" => :high_sierra
    sha256 "3b77f2c70767fd9db2ce5382f59a271cf3de5c8ddda326f9049b0e27aec64070" => :sierra
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
