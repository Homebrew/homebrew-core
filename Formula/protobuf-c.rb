class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.0/protobuf-c-1.3.0.tar.gz"
  sha256 "5dc9ad7a9b889cf7c8ff6bf72215f1874a90260f60ad4f88acf21bb15d2752a1"
  revision 2

  bottle do
    sha256 "7d29f8bca03fd6d9ff9b54a486a64b8799115be31320b1f1619b5c8a15ceed3d" => :high_sierra
    sha256 "88fc4138caca5d7c56829b875ee6a16b1cb3d47249dbd197382542300d9146d8" => :sierra
    sha256 "cb09232e07eb174c8e40bd4b823c6dffe41fff88eb9f3b9b649d130d16b94186" => :el_capitan
    sha256 "b39956193b7c3cc9006370c9adba8b61b88980fcc8fffc705f6b8524e76b65cb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
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
