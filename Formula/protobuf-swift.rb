class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.21.tar.gz"
  sha256 "1735b6877335741626029c67dc6c05435548b236536a81d68fda2ccafc3519d7"

  bottle do
    cellar :any
    sha256 "08058da2661a4dff13310c80497f0883e0ec25615f2035946a39500cae2da417" => :sierra
    sha256 "e51e72c9fd962f3e1c4c9a9d963b1f5cf8fd463cae6e672657d786eac4bdf273" => :el_capitan
    sha256 "ca5bd070df6c0556c7e7e974391143d0dd09885c83d42b1067e8a2b3cddfe5e8" => :yosemite
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
