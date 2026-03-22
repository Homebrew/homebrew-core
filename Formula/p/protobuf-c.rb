class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 13
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a33506851ee7cd58481af48b15a49bae8618f86e90e4d1a0be8e711cb01a817"
    sha256 cellar: :any, arm64_sequoia: "eee12301464448819eb1c0052df63c18fb45adccf5e27135f232662552adfcb3"
    sha256 cellar: :any, arm64_sonoma:  "7e827adb8a62a0d40fa19f65f177986dcf5c40615582ef3d85e60a1acb4c3a87"
    sha256 cellar: :any, sonoma:        "e5636f30eb752a3155c38e974dda38734c5ddcc59947564a439670d4a3656bee"
    sha256               arm64_linux:   "0184eb879a953953c2397218f68f1b86b6d1493766c6f555c92bb5da53240c73"
    sha256               x86_64_linux:  "78e9b6bd905c1531f3ad143541a5d568a9e513c1c67a660e3f1af837c52bd9e0"
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
