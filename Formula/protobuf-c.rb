class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.2/protobuf-c-1.3.2.tar.gz"
  sha256 "53f251f14c597bdb087aecf0b63630f434d73f5a10fc1ac545073597535b9e74"
  revision 1

  bottle do
    cellar :any
    sha256 "b8f11ddea9ef19b5deccf1d7135f2bc3bcfb317ef1d585d134a353b22549c4f1" => :mojave
    sha256 "5c4a17bdd6fd302f88a08683ab0406fd621b6d819e6ac2ea385e40867acaae0d" => :high_sierra
    sha256 "805e3df27ba54bfdd1e76b0d6603f47622e73726e1483f080f8e8ff5238cbe16" => :sierra
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
