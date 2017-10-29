class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.28.tar.gz"
  sha256 "dfa07e41ddc790d3373e16195c9bee8512ebba34979aeb70357a922d6ac7bf7f"

  bottle do
    cellar :any
    sha256 "7ec6a24157ce085ad99ff05eeb42bbce0ebb642e4a2a887e08910a8717215e37" => :high_sierra
    sha256 "170011008df1434a264a56a8caf06179a7a12a72fa76f157ab430b708f8ca044" => :sierra
    sha256 "bf8767bc7336ddb47db5d2dcf8708062090e7e9a7153872a0406ce586b71c632" => :el_capitan
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
