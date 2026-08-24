class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 18
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "224d1a4274360e9bb9f6978590dfba7f4cd2b8117a3d78924b519fb5cae2b29c"
    sha256 cellar: :any, arm64_sequoia: "3e9dda2db5367332874363c93004038c3721b7b0d9cadd259aa2ef3972f324f2"
    sha256 cellar: :any, arm64_sonoma:  "53d97d97edc83b70fa85cb0e1ad0aa9bed0e9a0fb2fefe2c27c3aee0ed584fdd"
    sha256 cellar: :any, sonoma:        "01d46fdbd673b5057e1f91b49f64c9c7def7255b6e6fd794aee2a53e0e2149bc"
    sha256               arm64_linux:   "7274627aeb63d76841695881300cd2d515aca8785d4be0aeefaf3b8f25e2759c"
    sha256               x86_64_linux:  "871a94e5219259e793c7ab2aff5380baaa54a836731b0b36b8625b3aacf858a9"
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
