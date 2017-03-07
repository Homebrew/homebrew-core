class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.13.tar.gz"
  sha256 "79bd0604bf8a41120334db94c84c49f9f03c0796a0f985774bf361a659e474d1"

  bottle do
    cellar :any
    sha256 "b46f21de24e8eeeda1ae4326f6a4951a588b1b061046bf7afe747df691ac668d" => :sierra
    sha256 "c5f9f6601cd61946a6b9ab05fc3b9a1f054cc4dfc9ff8f8525f3f1ed70b67679" => :el_capitan
    sha256 "7d59e5b818a9a0975d6aac5c6cb6e642eb87cfa4806a50958290d4d8fc06b363" => :yosemite
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
