class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.0/protobuf-c-1.4.0.tar.gz"
  sha256 "26d98ee9bf18a6eba0d3f855ddec31dbe857667d269bc0b6017335572f85bbcb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "df70c1823bcc700c5cb2d774b7449d2abd5f7b47328038204f9d62077d107b13"
    sha256 cellar: :any, big_sur:       "c2ce7d930cf3d8c82d88623cb10e6d9e0b0827dd430ce44edc63a9aabdbb47e3"
    sha256 cellar: :any, catalina:      "a4568baed3b991990221ee0c90183e5e09911f7b4ad45c79570409b5f659b739"
    sha256 cellar: :any, mojave:        "f6b3ee99315a6ff4d418d208afd6722fa271c72c6f7ad52d6535c5666640a3fc"
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
