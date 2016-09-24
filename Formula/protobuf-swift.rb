class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.3.tar.gz"
  sha256 "8b95bc8fad66b058f342ea489d37c2c607d2cfde6d005365f0f30fe503dc4ad1"
  revision 1

  bottle do
    cellar :any
    sha256 "da0fddcc620b25bb8232ccfe8e85daafb9a3f64673dbe8a4bfa34780dc96c675" => :sierra
    sha256 "bebe1c6cc3d318a9f97bf2c4ae2838e574fffb6c67ec7320c86712891d6e4d13" => :el_capitan
    sha256 "a7443e675f5612969316983d7ebb34e76006c806cf9bdc0ac6fe5c6af8840eb7" => :yosemite
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
