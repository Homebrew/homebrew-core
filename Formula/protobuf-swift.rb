class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.6.tar.gz"
  sha256 "598d9e459b4ac74bfbcf22857c7e8fda8f5219c10caac0aa18aea7d8710cce22"

  bottle do
    cellar :any
    sha256 "64c6b817c6d228fc67069f71b02c22c417ab78c5a9af5852cbc97288a5c68359" => :mojave
    sha256 "c6c9d9b4d5297302f46c61815f8dc312daa18038462efb3a5678406732ebbebe" => :high_sierra
    sha256 "94a30e32d24bb183e2b27a5fb6f47204b563b579e0d1e2daecb3c615052bc072" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  conflicts_with "swift-protobuf",
    :because => "both install `protoc-gen-swift` binaries"

  needs :cxx11

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
