class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.1.tar.gz"
  sha256 "098434ab76cc489c92100c0352d4476259737ed925d2c98d267848e7c8be80aa"

  bottle do
    cellar :any
    sha256 "f323ffe49504ccb6e58e0c33ff8081a414c70e9367153b5af156347a78ee8400" => :high_sierra
    sha256 "1b6e3b8f3dd5239be11e14aace8a5c6643397f6229d75e9fcfb13944c776ce4e" => :sierra
    sha256 "f07eedd501be82d175ed46ebec1ac4ab0b693ba966d0f0f99c45c3f2702e717a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  conflicts_with "swift-protobuf",
    :because => "both install `protoc-gen-swift` binaries"

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
    testdata = <<~EOS
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
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
  end
end
