class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.15.tar.gz"
  sha256 "2131366f4b81d68660dfbccf3ad06188ea62a7928fbca922a6969adbb0696606"

  bottle do
    cellar :any
    sha256 "f5ea1cfd1020eea0d2c49e50d98ba7a7138689f755cec44f78ec8cf48d81a7e7" => :sierra
    sha256 "764df1b7879dcff5a30911cead04c3919374aa829434d8741857d22a6da1bc8e" => :el_capitan
    sha256 "9a4ad148e354dd1e2760604df7839da3131071544c9458800e84224bb26126bd" => :yosemite
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
