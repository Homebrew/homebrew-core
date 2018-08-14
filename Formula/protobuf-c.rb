class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.1/protobuf-c-1.3.1.tar.gz"
  sha256 "51472d3a191d6d7b425e32b612e477c06f73fe23e07f6a6a839b11808e9d2267"

  bottle do
    cellar :any
    sha256 "3486e2c1d4d3c8156fbd752c695702df5ddde99f858c12a0f98266a4e76c9157" => :high_sierra
    sha256 "0ce7864014c70e653332527804ad07039406f3563204f4f7e66612d682c1a480" => :sierra
    sha256 "193f27c0ff5c6dbcd2b1eba8572fed7b91f66866ec4c323ba9b4b6189886146f" => :el_capitan
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
