class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 12

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "62765efeffc1718219c4b6ea9c8a89ac60bfea91033d96198e7339dfffcb39dd"
    sha256 cellar: :any, arm64_sequoia: "512408e7a115af37693098cb9faffbf1683eea4d13e49232c8edfc6f8dbfb439"
    sha256 cellar: :any, arm64_sonoma:  "f9f5f7aaf834abf0cb6970d9f9e362bfdb6d683ef47242a84013c743d067260c"
    sha256 cellar: :any, sonoma:        "f5848c768685865a7cc555663ad6a6b1a884718ca7f5d6b871a1a1ebd33337a3"
    sha256               arm64_linux:   "723ec26a710c65eafaa3bd28680dfba439adec33db21daf303981d08237c3710"
    sha256               x86_64_linux:  "17d81688a3d374768a86411d0201af0f46a4fd0a62f2c102be5bbd1b7a9a4513"
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

  # Apply commit from open PR to support Protobuf 34
  # PR ref: https://github.com/protobuf-c/protobuf-c/pull/797
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/d39f001b4578966600de0aaf7fc665eec6e057e5.patch?full_index=1"
    sha256 "10b5ea9c08f62be10ceb1df24a3211118a94cb0d09efcdf043ac3542368915fb"
  end

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
