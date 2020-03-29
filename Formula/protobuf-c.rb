class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"

  bottle do
    cellar :any
    sha256 "d3d18a6f8ca5566c980b7f96f8dc6dc1068a2cb0c922241590d7df2199385597" => :catalina
    sha256 "26c3fd5bebba098312f8ddbd11cd54295624a75c40663dd6e1d8109144a733e2" => :mojave
    sha256 "162d74ce599bfe498da7b3846b2d9305efca113e6f5a2a858cbdc9024acbf303" => :high_sierra
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
