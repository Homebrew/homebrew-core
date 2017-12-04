class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.1.tar.gz"
  sha256 "098434ab76cc489c92100c0352d4476259737ed925d2c98d267848e7c8be80aa"

  bottle do
    cellar :any
    sha256 "77b09439860f53d4899c8df8a27e004f57ec900266f04afe25ebbf2d86daddbf" => :high_sierra
    sha256 "10edd63a5c5a366884365ea2d0f4dcf4e8f39f099348989e6e61c71ee98cb08f" => :sierra
    sha256 "b044fd727cfa69e55d34e050d7be4798c8b54bff5494244a2cafb43b216ac107" => :el_capitan
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
