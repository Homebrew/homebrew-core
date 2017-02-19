class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.10.tar.gz"
  sha256 "1d8043faae3f1ca5ec077b0bb2a0403db75aa4854daf76282fc910de4d567d5b"

  bottle do
    cellar :any
    sha256 "36c78adb380bbdcca544bb07453d2b7d82da409923b886e8587cfb3ed9bb9b40" => :sierra
    sha256 "19bb7725e805e765675b1e04903e7b9e7fb835a84145e213f861c4a5022af48c" => :el_capitan
    sha256 "c3943f2fd9462dba14e5b7449bcb8603d28d2e2f912454e62da0ec5fbb8e8d12" => :yosemite
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
