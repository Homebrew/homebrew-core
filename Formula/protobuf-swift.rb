class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.9.tar.gz"
  sha256 "1f5238de73ca0a5d28cebbbb57e9392b4dc49316a00d7d53701b2852d4ea2d63"

  bottle do
    cellar :any
    sha256 "610aa5da8d405eafcc33e2143e1d967fd3e29b4a944982a1d824221f67e46153" => :sierra
    sha256 "179311436210bcb9a054103308a1faac672562f6d79bba96fa24d5ae8dd9dc59" => :el_capitan
    sha256 "b96e6f7ccdb89ce78581635bf012306aae9293a365f1e8d09232fff36e5fc0e0" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
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
