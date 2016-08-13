class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/2.4.4.tar.gz"
  sha256 "c5960def4f9d48d4933f1a1ff1ac403ca278c0502ee048c6c8704d769b0ae7c5"

  bottle do
    cellar :any
    sha256 "17cf44adc252e062bc9e63cdf2c110066c6b0ad0c994be7feaa1f35fe7b56831" => :el_capitan
    sha256 "6346f4a7adda25f013c60e3d9bc0e158d571a6007d0dca6d1467525248b41345" => :yosemite
    sha256 "a7eddb2d6c52a560242b8cb8ed819d9e028f52029df6fdff2f77e50eea1f449a" => :mavericks
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
       enum Flavor{
         CHOCOLATE = 1;
          VANILLA = 2;
        }
        message IceCreamCone {
          optional int32 scoops = 1;
          optional Flavor flavor = 2;
        }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
