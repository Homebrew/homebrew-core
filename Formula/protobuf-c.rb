class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "537aa180b45b68c137ab083b1ff95d02e2080a83e3233c699d405811ee1f1fdf"
    sha256 cellar: :any,                 arm64_big_sur:  "489ad850a2ca931946aed658164352355ed1288361ad625cb675c337d3af1208"
    sha256 cellar: :any,                 monterey:       "d610c97326bfe698e787b759419ffdff30a3062901de34b04b94b880b4be7bd5"
    sha256 cellar: :any,                 big_sur:        "0ca76ad36b07e04fc5bd398305bff9220c894d263afe2ac4f0405b65c98c8e31"
    sha256 cellar: :any,                 catalina:       "225a8e1721d2b38183513c0dc945426e0b314369da9b59cc1572bdf09591b7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703559f4e51db1101be80e9845c74ce83e40bad910d993d1a590f24eccd50a78"
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

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
