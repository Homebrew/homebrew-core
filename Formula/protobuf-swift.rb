class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.16.tar.gz"
  sha256 "6505f2ea50a2f226ebb0f14910f7d05e7b8343c191ef848e226db1c8feb6ea67"

  bottle do
    cellar :any
    sha256 "cbbc91de8815e31126b9c389ec8ee97735e04cf037321e22729b0a67652dd6de" => :sierra
    sha256 "31b69a6da1b98f21ebbf7be0565bb585e01cf4a4be64c1da71e16708cad73ec2" => :el_capitan
    sha256 "2f301bf2e9203bd54d302f7b2c60a19fd67c3837e575146d0d86bf76c1e97bb7" => :yosemite
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
