class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 14
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "08e2fc52bfa20a51577ace57a76d5529f792c6c7441601eb8264e2b174271a35"
    sha256 cellar: :any, arm64_sequoia: "6d386d7b7bc044a6eef811765f62d35dd968eaafbc33093bff227bf7d72707b5"
    sha256 cellar: :any, arm64_sonoma:  "48be422f6f17c7842ebdba69f65f5cd567f50f54891dcaf2fed3fb6d5d2a0ae0"
    sha256 cellar: :any, sonoma:        "bba3e88a54a8d0bfd56953c7721467dd43bbe487fac8ff9d15f15cc043397359"
    sha256               arm64_linux:   "1745958c8643bd94e5e8e7321cc6506e5babcdeb87b9a1cd5b084ca8de07083d"
    sha256               x86_64_linux:  "af081874a015d16cf235afe1de0c5665052b2f98ac5a5bc90b2ea5a2fa8f04ed"
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
