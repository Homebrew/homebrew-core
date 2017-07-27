class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.22.tar.gz"
  sha256 "3d24391b0e91c0bf665aa045b99279300b6ebaaf0aff18a273b5f39aabcd3700"

  bottle do
    cellar :any
    sha256 "65cd90c672f018a57172d7bc41e4ad94239ff45ac2de4de2d260d876b9d3c35a" => :sierra
    sha256 "4fb357f512b3644d645f5edc8e626020ecea7546afc6f5badccd67e40829960b" => :el_capitan
    sha256 "d0c61f9b82b0685cd3ed967dd3bd4183db77da064cfcd6ebb99f9b49a19a9a8d" => :yosemite
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
