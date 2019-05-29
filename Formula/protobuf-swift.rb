class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.6.tar.gz"
  sha256 "598d9e459b4ac74bfbcf22857c7e8fda8f5219c10caac0aa18aea7d8710cce22"
  revision 2

  bottle do
    cellar :any
    sha256 "bae411c98ef6433579d163c3768da147faa3f467dd9c194c1de0edc57fbc1863" => :mojave
    sha256 "ac056837e13336ab4a19148fcba9638b2598409ef81eb7fda97f8db3b4bca573" => :high_sierra
    sha256 "810002a7d999354ec824b101a8c3fd78c7316302fb98d2ff056e577f2aafd9e7" => :sierra
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
