class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.5.tar.gz"
  sha256 "12b41b86d6ee3146e41f4a36ae9f6a0954be98a76489bc5b0d1cba55cb7067e1"

  bottle do
    cellar :any
    sha256 "fe0ef32a28a976252aab4a376f565d4a74503e7ed55ff5664592b6204fce2eea" => :sierra
    sha256 "34111b4a353fed7ff69d1a0e2f2fe5f50997cfe396606455aa673f1fc14be51b" => :el_capitan
    sha256 "c6fd4e7354cab8ed582ab773ba4a4cba3f36fc70eb85f8986c8497af690580d3" => :yosemite
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
