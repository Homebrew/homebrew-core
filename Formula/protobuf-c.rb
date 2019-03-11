class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.1/protobuf-c-1.3.1.tar.gz"
  sha256 "51472d3a191d6d7b425e32b612e477c06f73fe23e07f6a6a839b11808e9d2267"
  revision 2

  bottle do
    cellar :any
    sha256 "613e0a3df1b9dbb35a1a953d436b82eae60b0a905f122603d337ffccb7157455" => :mojave
    sha256 "3b5e1bf7fe80fe15a1eff307e31f7aaacbb572855fa6a390d1f603e927b4530c" => :high_sierra
    sha256 "c2bd07c29b6b7371f7b58a462f1b45895d8ae302bdf0f7ce8c7c53529bcb715b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  # Fix "error: no type named 'Reflection' in 'google::protobuf::Message'"
  # See https://github.com/protobuf-c/protobuf-c/pull/342
  # and https://github.com/protobuf-c/protobuf-c/issues/356
  patch do
    url "https://github.com/protobuf-c/protobuf-c/pull/342.patch?full_index=1"
    sha256 "7890af8343be67ac73ab0307ed56ce351004d64dbddef6e53acd3b4ad22aa7e5"
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
