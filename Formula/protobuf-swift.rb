class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.26.tar.gz"
  sha256 "a74aed7c5dd809c51996ee5fef1a973310540ffa0f9c846f7530f522dbd87ab0"

  bottle do
    cellar :any
    sha256 "1be5203b5773b972387e6ad5f363957ff79cf7524c57e2f5154b5984403680f4" => :high_sierra
    sha256 "5eabe4656fd3bf3b9b8e45bc16ae77ddcc6499124aecba187592fd4777632e50" => :sierra
    sha256 "9475a40826aafbc4d647532aa6f9e670f19cb54da00f5ad439111f1719ae594e" => :el_capitan
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
