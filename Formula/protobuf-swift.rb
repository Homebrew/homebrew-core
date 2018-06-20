class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.4.tar.gz"
  sha256 "5f95c202b3e600717577bec410e19329322291b30d3c4ecb828a370a42d13d3a"

  bottle do
    cellar :any
    sha256 "ed9dc01b74d2c0e61e15465afbf8a68c07e0b45ed1471ceba058eb9b6a971c39" => :high_sierra
    sha256 "820c1172c30bcc479c2026b33b7f0dd2dba04a90c2570c08b4d341b38d701c01" => :sierra
    sha256 "3e4cb83d61ccb4f9b9687c386921d3c2f26eb3a159e0f112a6e00529acd8eb05" => :el_capitan
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
