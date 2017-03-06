class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.11.tar.gz"
  sha256 "0eb6bdcdfe2ef4ff0f1771336a26c70be68272e585efa4c2aab37ca298a7508e"

  bottle do
    cellar :any
    sha256 "44cf488eb0793a469d594b55690a1a664de92f03b0a79a5e2f3fbad6701c71b8" => :sierra
    sha256 "38dd50b43bdab0177f8e06111a67552834ba36a7c9788b608872f7b9343b8ec5" => :el_capitan
    sha256 "57d59fd0d20b9dbffbb855894cfb7965c2ba403a7601c6bb884ef8b06039af9d" => :yosemite
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
