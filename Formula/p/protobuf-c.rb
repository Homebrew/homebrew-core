class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ed9a5f8bb5697de13d3ca2e656e81d4d2a34dbbc49de0293d288274305f84f7e"
    sha256 cellar: :any, arm64_sequoia: "77645079f70331ad9c82b4337a3ab868c132638f5dd36530d80bf4aeb0e2b733"
    sha256 cellar: :any, arm64_sonoma:  "4268cf8ee226e905ffe01ae3cdd1d1376c65ee096be98a62714c7d9b81f7a0f8"
    sha256 cellar: :any, sonoma:        "805343efbea53481862e784b02db2981d383c3fce3ddd82bae53fd5eb82590be"
    sha256               arm64_linux:   "12d0d2fc6bd089d669f14c5620520c5debcf2d7f9f8ad46829ae722e933bdb24"
    sha256               x86_64_linux:  "e34cda18c7ae5eb4faf3271882849f143a355da4915ca3f52916375c456555e1"
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
