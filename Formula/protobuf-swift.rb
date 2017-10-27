class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.27.tar.gz"
  sha256 "25b3d0de3440aa4e49aeb7bed3e8ee2c7f507c95f37bc84e564d50978dcc63eb"

  bottle do
    cellar :any
    sha256 "b2246aa58b16be8a8b508dac77c8ae581439f0896b0d68d15eaf2aeadfe8f2ec" => :high_sierra
    sha256 "d6386f03d7204273d26bdc2ecc7513c4ab6c0069d6acf94fb003fdcca7305ed1" => :sierra
    sha256 "b9e53794e2e508cc2f09fd00abe592c9155253a1ba85b72036f19f9327214d09" => :el_capitan
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
