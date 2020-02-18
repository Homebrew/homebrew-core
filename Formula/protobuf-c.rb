class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"

  bottle do
    cellar :any
    sha256 "25a02fa1dd64b92a0b42a1b667913171ce916a582001347efd381f277d6e9520" => :catalina
    sha256 "6e0394c6a683e5dff158e6e3c8ce7853c8d61ec724bee71e59958f7a971e38cc" => :mojave
    sha256 "a57fb197c07333576ea4e9df0ae138c33bd3198111dd0f5a25ed638259485790" => :high_sierra
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
