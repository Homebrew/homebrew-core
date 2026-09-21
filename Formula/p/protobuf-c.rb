class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 20
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "85448989d575d6446049b55ceb00e124fe10926a7e821260267751e46f40e6fa"
    sha256 cellar: :any, arm64_tahoe:       "5e0c76470b2d4a38b1da787b4c4c4f8068777fe539ba246671c430caa2b4944b"
    sha256 cellar: :any, arm64_sequoia:     "69edb8458f7665eebf89cbd4a17a5440da7916d395301b8daef1d0495fb1d6c3"
    sha256               arm64_linux:       "31130879b840f0b5d44b5b11704c248198e752378ba49113c0148edecf0c4d2d"
    sha256               x86_64_linux:      "209741c1388b065927085210e42586dffd273107b5d577b7373cefaf8d661dc4"
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
