class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.4.tar.gz"
  sha256 "1193b3b98fc95cc6e179487516a4973028920dd53340276cd099b67aa1d78217"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65cdfb2ff5429682f87b914df3ae1dccacf2573a120209e0487da7e82dcff581" => :sierra
    sha256 "45860a988a2c57a45e4b3cf7327d0dcf193b17fff3c068454b26393f5fcb5219" => :el_capitan
    sha256 "c134c5d5821796ac811a08e833ecd4fe3780fd172395e8b2c1dddfe2833e013b" => :yosemite
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
