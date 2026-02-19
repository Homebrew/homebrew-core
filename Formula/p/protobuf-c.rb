class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 10

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf90b00eb0059e3c986ac5019c55cbea1022f3dbae573d1788a1df86f1c878d9"
    sha256 cellar: :any, arm64_sequoia: "9ee5190e0ca1d8c231f37348cb7ca19e37818752d8a54f1ebed17d8146770a2d"
    sha256 cellar: :any, arm64_sonoma:  "77d70e573f2fc4c7d681f2f585e6397828a4af68b3c50195ed5d55b84fe5effd"
    sha256 cellar: :any, sonoma:        "dbb1667ac23923fcd24cb34b8355ed5dc604e78e71c33fac1aa8a34548568692"
    sha256               arm64_linux:   "cceca237a913c2fb058fae18c75bcbd98402b89b239f53e69ec7be4065066ce3"
    sha256               x86_64_linux:  "aa9d957fe13badc52c65ad16e475e0d681a6bebe2fe502468bef8a12cecf6edd"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end
