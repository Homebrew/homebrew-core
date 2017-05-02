class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.14.tar.gz"
  sha256 "6ba6746f7036fb0274df5705406e6bdb8d8e2c7fc5a30bc2348dcae1d7cca39d"

  bottle do
    cellar :any
    sha256 "548e641331ec73b13ab0ae35b09721bd8c307f62f9cf98cccf5fae094d2b2871" => :sierra
    sha256 "9204e63b8e8dd6f6db6dbc3c238bd00041a9fa8d4db4c738a50a00144b9e1601" => :el_capitan
    sha256 "b6cbc90ab228e9a717fc12e142cfa92888a9d067d9feed393bb99298492bb361" => :yosemite
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
