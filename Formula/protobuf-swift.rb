class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/4.0.4.tar.gz"
  sha256 "5f95c202b3e600717577bec410e19329322291b30d3c4ecb828a370a42d13d3a"
  revision 1

  bottle do
    cellar :any
    sha256 "fd3fb66e37f3996fafd46c9a0bbb5fac6ed803f22a1c0f5eaf6188a89de7dd90" => :mojave
    sha256 "b0094c237e1b23010d092f334731c04ee984c8c5ae5e9e144f67c9c073dddf6b" => :high_sierra
    sha256 "af7fc43b9124b46f986c0a582d51db2146c9af17f229647e1991363afffd7af6" => :sierra
    sha256 "c078d07e655a9346b5ba669761b311488d81565ffd195bec128426090ee38bde" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  needs :cxx11

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
