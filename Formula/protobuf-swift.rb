class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.6.tar.gz"
  sha256 "279c24886f5a88f332db2e0f745de55b6267e697ce4ba42f7d91566b6cf11be3"

  bottle do
    cellar :any
    sha256 "0a7d4ae9dc64460cb8a948e47109ff802198bea55f3c2506611a75b7926f16cd" => :sierra
    sha256 "eaf517e7525e8a5968460229268c264d9c462f05caa4f09903ace835bff850a0" => :el_capitan
    sha256 "7d3cf13a1ce4d89a4b07e40b2bf26ec115a0c6d0d9408b8a580583be8ced01f4" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
