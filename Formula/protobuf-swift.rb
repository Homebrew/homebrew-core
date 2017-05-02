class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.13.tar.gz"
  sha256 "79bd0604bf8a41120334db94c84c49f9f03c0796a0f985774bf361a659e474d1"
  revision 1

  bottle do
    cellar :any
    sha256 "5abe4c9ab221cb9b811b1ed890880fe1e7f4321b31a09ab235a007fdfd7035f2" => :sierra
    sha256 "fd85d35cb5171e0b0e3b3bf1f1c4df5226ecef5d6f07d18203c509bc1001ec06" => :el_capitan
    sha256 "4fcbfbbb9df64196e2b711ab3682905196aac768bebdfab00aec1c87d24ad133" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "protoc", "-Iplugin/compiler",
                     "plugin/compiler/google/protobuf/descriptor.proto",
                     "plugin/compiler/google/protobuf/swift-descriptor.proto",
                     "--cpp_out=plugin/compiler"
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
