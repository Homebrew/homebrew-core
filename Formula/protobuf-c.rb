class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.0/protobuf-c-1.3.0.tar.gz"
  sha256 "5dc9ad7a9b889cf7c8ff6bf72215f1874a90260f60ad4f88acf21bb15d2752a1"
  revision 2

  bottle do
    sha256 "8f56aec07a20c79a5d01c7a8d30946d1b86c157d24468e8160edbec318046b71" => :high_sierra
    sha256 "276829169dc5d00b9c14a4542c67009aed3b9049ece5f30aa1bce20bd4f5e195" => :sierra
    sha256 "65e9d6cecfd8cbf6c40cce2a5c16d50c1102a605d1e919c66ca316e7c1046e90" => :el_capitan
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
