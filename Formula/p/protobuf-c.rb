class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 17
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12fe5dd9e8a0e213423f19fff3615af2d5bd9beeb6a3f0612b10f1e25ffd323d"
    sha256 cellar: :any, arm64_sequoia: "ce004b3bfd362fce6975373453ea23de33da42dec394202b99ef31307bdc46c7"
    sha256 cellar: :any, arm64_sonoma:  "341a7ca73a47d0d5f02084e04011012f6060d22e5df2da172a11fa895459cf97"
    sha256 cellar: :any, sonoma:        "64134f5fc8cf3fe4e3b1e392c6314deda752c03cbdb104f53d805c849c29effe"
    sha256               arm64_linux:   "8242722d9ac36ebf7340c20845abf2d11a7fc32f4baead3ac75f785fb1072983"
    sha256               x86_64_linux:  "bdfc407e535a37369e578a1ce3d0baa9475aab62c336fddad64315ac77075c0a"
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
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/d39f001b4578966600de0aaf7fc665eec6e057e5.patch?full_index=1"
    sha256 "10b5ea9c08f62be10ceb1df24a3211118a94cb0d09efcdf043ac3542368915fb"
    type :unofficial
    resolves "https://github.com/protobuf-c/protobuf-c/pull/797"
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
    system formula_opt_bin("protobuf")/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end
