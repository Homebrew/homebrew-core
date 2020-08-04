class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "2af1cf51bac889177c41922236c9a1433749952e4bc76e7a7493bb9c96745319" => :catalina
    sha256 "0a8fc62ce9acd99178e21afc4a994cb762c9e13a3d3fec887a19ab0706f9acc8" => :mojave
    sha256 "1a66fd256c32caaff9e52748fd7f9987580b36425682d5a6263c0c0db011c405" => :high_sierra
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
