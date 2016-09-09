class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.0.tar.gz"
  sha256 "3e93f410844049673a164698589f1cb2c8f8ee1e4169b6cee3c6c32f8f5c4edb"

  bottle do
    cellar :any
    sha256 "fef0ef655c4f0ed5a52af75feb21671b9bd15a23cf963f60ed18c11db8195c97" => :el_capitan
    sha256 "ac48308787de32a447bde77e700b06c6a2a956b7a38cfee8231b940cd1b94674" => :yosemite
    sha256 "a4f13c53036de42e34644af5278488ace202c822259dd7a87958554fadb51585" => :mavericks
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
