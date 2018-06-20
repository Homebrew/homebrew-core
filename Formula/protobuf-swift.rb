class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.4.tar.gz"
  sha256 "5f95c202b3e600717577bec410e19329322291b30d3c4ecb828a370a42d13d3a"

  bottle do
    cellar :any
    sha256 "7e8f01b75f5115170229c3fda369c9428bd85c71c61d39cafea151bb299b821f" => :high_sierra
    sha256 "743df52b16e0e60b1a40376790a921095484694944bb87625ae20f1040ca8685" => :sierra
    sha256 "ae28de5761dca14876e250adf3c19b61c7c74373d0b4fa7e19d42bcdabd1894f" => :el_capitan
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
