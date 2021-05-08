class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dc8643143d2aba5a8c36031dcec16a1d74a20d0eb3c2b9bf23f0aefd2d691482"
    sha256 cellar: :any, big_sur:       "fd79bd37ab642c297fd3b7b79cc272a0ae5bc59543fb5ffb946a4f794ca0febd"
    sha256 cellar: :any, catalina:      "1adba896481ebe75d7808cd3102a923663a5d7e7e1967fb0b3b43e0675ce352c"
    sha256 cellar: :any, mojave:        "64b299388306d438f2d0fd2699e1b256849bf0ed6935da383abffa0afa0b193a"
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
