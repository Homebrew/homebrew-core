class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.1/protobuf-c-1.3.1.tar.gz"
  sha256 "51472d3a191d6d7b425e32b612e477c06f73fe23e07f6a6a839b11808e9d2267"

  bottle do
    cellar :any
    sha256 "f34001d304aba14031d91c27eb8262431b7423936c1d16fe803ba751b4d79b6e" => :high_sierra
    sha256 "cd1d4d0e7586c6068e1429ebf08c12810290d2e33f248ba54af82fdd83d30956" => :sierra
    sha256 "34f20c4367ae1d7e61dd28de40cbd910a4e81d7fc6b1b186c93bd6f55aa89eb3" => :el_capitan
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
