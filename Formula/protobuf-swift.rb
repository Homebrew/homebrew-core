class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.22.tar.gz"
  sha256 "3d24391b0e91c0bf665aa045b99279300b6ebaaf0aff18a273b5f39aabcd3700"

  bottle do
    cellar :any
    sha256 "e98bcea54d09bb9f36433e10373f9cdab41f2056c3136ee161dbee7ecc504652" => :sierra
    sha256 "e5bb9364ac53d4043247378c64f1ca4072dcbd5e7fa757f51d301a96132fa38d" => :el_capitan
    sha256 "7202885524fd6601793f3a739f45bab6ff4dd9164378cf0e4534c10e6dda5a80" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

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
