class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.0.tar.gz"
  sha256 "4ffbf2e2dc6492fb9b44df2b78695d877b77552ad0e3dead4279c13ebb0e5b36"
  revision 1

  bottle do
    cellar :any
    sha256 "acf8299172da9992065ad37badc4c5f94996e3ab10ae89dc60e1c62104af6e9e" => :high_sierra
    sha256 "7e08753b594cf49d61b96479b30dd3be69640a0a73629a0376882682a2b34e5f" => :sierra
    sha256 "b0f5abdd5799f13111fee8a9cbbf7f2a77c2219d2d5d10cd3be294c27efbdef5" => :el_capitan
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
