class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.2/protobuf-c-1.3.2.tar.gz"
  sha256 "53f251f14c597bdb087aecf0b63630f434d73f5a10fc1ac545073597535b9e74"
  revision 2

  bottle do
    cellar :any
    sha256 "a6cb3873be6a01f5af461f2ae4313113ff83f5da197ed0c7a8bb46f17d053c5d" => :catalina
    sha256 "bbae72fef42a1022511522cf2d8056799a70dac35a9136b77ec7e6b33a69b090" => :mojave
    sha256 "d5b64d290c16524c4b67c21ca98011cc6e535754f17bab2bd7c9a6323dbe354e" => :high_sierra
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
