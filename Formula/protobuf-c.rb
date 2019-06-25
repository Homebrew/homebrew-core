class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.2/protobuf-c-1.3.2.tar.gz"
  sha256 "53f251f14c597bdb087aecf0b63630f434d73f5a10fc1ac545073597535b9e74"

  bottle do
    cellar :any
    sha256 "613e0a3df1b9dbb35a1a953d436b82eae60b0a905f122603d337ffccb7157455" => :mojave
    sha256 "3b5e1bf7fe80fe15a1eff307e31f7aaacbb572855fa6a390d1f603e927b4530c" => :high_sierra
    sha256 "c2bd07c29b6b7371f7b58a462f1b45895d8ae302bdf0f7ce8c7c53529bcb715b" => :sierra
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
