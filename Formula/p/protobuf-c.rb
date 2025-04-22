class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4c6dbe4ec1d26e23e6e64fcf119bf6b09c558fb4433a53be2e2de0e1ed6611a"
    sha256 cellar: :any,                 arm64_sonoma:  "2c43aeeb810402ebfda6130aa5c542e039ef220430beff018ea5f882d2507ff9"
    sha256 cellar: :any,                 arm64_ventura: "34f6256e4e965cb4feabad6f18797443f9b8828019e2a8952ae5e4d71a180b13"
    sha256 cellar: :any,                 sonoma:        "3bf90fd0fb9e303a6c50b66e2ac116c30a81b45491b3345027f3ba6d0e87e841"
    sha256 cellar: :any,                 ventura:       "7489118f2098d2374da1776d28924c0830a235ee20128383d0c7deae7ed7e04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae0763672aca79ff944c60ecb03b040c47f7e1f6be998f7c473977ba9d689fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b145453b03874422ac9c7890113ae68c34c07d679ba05f47e2bab90b093a59e9"
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
