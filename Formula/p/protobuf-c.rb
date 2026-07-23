class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 15
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0daa060f463c2b639c9bf26f242247028d2fab31f173b56eceb5649a498e0653"
    sha256 cellar: :any, arm64_sequoia: "305421724da289d9e03fb00014c537af91082c0edcd88ae714d86a08897d9583"
    sha256 cellar: :any, arm64_sonoma:  "cd466a6ce9c6062c51f96b4f65382aef9079e4e5b17892adf97bc62c0abce98f"
    sha256 cellar: :any, sonoma:        "0494d75d1143e4630f95d7e1a49e3ebb030c3b8ae956cd3b6ce2e62174f576d0"
    sha256               arm64_linux:   "25419ad456639268f249504d08f3247a171c24a54062755b48d66b1c6c9cd1a8"
    sha256               x86_64_linux:  "22d928212aa632205d2b0ae7b93e0d3fb14018fe0ea973a5a175a3784440d1f8"
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
