class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.0.tar.gz"
  sha256 "f365312ac775ccbf923b32f9338aae7ff3ab156ffeae95cd25b476935baeffc7"

  bottle do
    cellar :any
    sha256 "c43485cc403a6b9bc8e60461b0e0661bf1c7ee025225e477b125c1f4df2df1d4" => :el_capitan
    sha256 "c1db979a35d13541f24d747b8fc0dbdbfca49122d2ac41b17fb1f52129804c0c" => :yosemite
    sha256 "c3f4a818f9adf7205e701afeff6d81ecc9cbcb610a68219023ff93d71d735424" => :mavericks
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
