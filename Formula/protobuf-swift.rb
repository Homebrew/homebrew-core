class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.24.tar.gz"
  sha256 "087a49c0d34a946cb8a28349b8d6706a8535df32c44b04fddba6c3916ab92c05"

  bottle do
    cellar :any
    sha256 "b63992b3a2b97651b710581680a611564105c36d4e974e54224922a73032736c" => :high_sierra
    sha256 "0f74a058dd5e3ca763f3839e94981322c9c4e543bcc236b311cc20d0c88f18c0" => :sierra
    sha256 "82030ac115812cf23eb628fbff924c38d28ae4349aee20105821d34e81a3a971" => :el_capitan
    sha256 "e0a8201e45fb731000f2c3b08b4d8dc8f6ae1eaf7754c9638e081f2462f403b1" => :yosemite
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
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
  end
end
