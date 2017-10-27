class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.27.tar.gz"
  sha256 "25b3d0de3440aa4e49aeb7bed3e8ee2c7f507c95f37bc84e564d50978dcc63eb"

  bottle do
    cellar :any
    sha256 "34d42e80c755879bea5bc161f8eac8983d3b44fe42faae45f21cc88f9d62e599" => :high_sierra
    sha256 "9e8d5bdac327ce682c19f1ac915d9e23592992e8ef17ddc0b90a9ed4eb473cba" => :sierra
    sha256 "255fe2e8fdfcbd6bf84e0ad753990e1c83b8efdbe315cdc1ca84d4c1ba32bd60" => :el_capitan
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
