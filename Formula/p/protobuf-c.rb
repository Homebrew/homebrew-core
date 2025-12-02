class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2850a6e2ad516db6e4b0ed3b086069d7a489e4acbef231f0cd05f8a8f6bc48f"
    sha256 cellar: :any, arm64_sequoia: "d9dd19bb74b2c9469405cea219337f8f864d638e18fe8ea00253331d88aaf466"
    sha256 cellar: :any, arm64_sonoma:  "ff7d1372a9e6f2d40d0dda7e6fded9c368cf955c6026a6a8e14282b90f32cd8c"
    sha256 cellar: :any, sonoma:        "d80278e079b54e7d4bfb3efbc3949094a7814d679635d3366bf2b1ebbc2a9339"
    sha256               arm64_linux:   "ca2f2be975f82480a90f477554b1f1c9d00f28062e6aa9e80606a1d7dcc779e7"
    sha256               x86_64_linux:  "6f0b1f8a499032b11b82e92e99b508af7aae0196f96d63ad5307ae8b17f59679"
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
