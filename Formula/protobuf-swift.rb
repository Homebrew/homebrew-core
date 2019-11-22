class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.6.tar.gz"
  sha256 "598d9e459b4ac74bfbcf22857c7e8fda8f5219c10caac0aa18aea7d8710cce22"
  revision 2

  bottle do
    cellar :any
    sha256 "25b96487d0f0d21de51d379e8d81e2dcc9eaf0252e779c9b340de0d089918f26" => :mojave
    sha256 "33f57aa9d49598a5101de975b92507964493da967b7a3738e91a64dd8a663180" => :high_sierra
    sha256 "42327634f717f0f9276d61af56df6a4595eea57f17d779f405703fdecae55bed" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf@3.7"

  conflicts_with "swift-protobuf",
    :because => "both install `protoc-gen-swift` binaries"

  def install
    ENV.cxx11

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
