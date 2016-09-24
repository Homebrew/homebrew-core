class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.4.tar.gz"
  sha256 "1193b3b98fc95cc6e179487516a4973028920dd53340276cd099b67aa1d78217"

  bottle do
    cellar :any
    sha256 "7a2f7c50880d584f68a7c7d84abf5026fa571410fca232c224d8acd37e3f2364" => :sierra
    sha256 "453d5457c0898adff1111d3cb1f78da1e21e13c6a88a4c75d4969aa3a598a77c" => :el_capitan
    sha256 "85c9ab5324dc1ab9ff1e3c43cd475d88fd64b1ad96fd5c6a73fe099620f35476" => :yosemite
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
