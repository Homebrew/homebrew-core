class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.3.tar.gz"
  sha256 "8b95bc8fad66b058f342ea489d37c2c607d2cfde6d005365f0f30fe503dc4ad1"

  bottle do
    cellar :any
    sha256 "6dcaa13c612e0920e4b3c32790b3c6bf13bd3b5652a154cfb88c76027ce3ba87" => :el_capitan
    sha256 "b5855e9466c7d2186cc06b6997c97c4de864b960fb44c99e8daa0145bca2537b" => :yosemite
    sha256 "cc684d65aa01a0b63c97357b4a5fcdd7ea9be8b2e67611c1d9490135cee74f17" => :mavericks
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
