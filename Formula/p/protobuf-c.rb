class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 19
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "282c17d9b2ad9a308a41c7c71ee99840ad68031088293693e0daab88cd462785"
    sha256 cellar: :any, arm64_sequoia: "2930dc4c8ec3525e2b96adebddc711889ce195494ed8c1a8fb028299fbbf6547"
    sha256 cellar: :any, arm64_sonoma:  "9c6f280748858232ef40d991642c6aec160e60cf59672d8e02f8439d66ecf960"
    sha256               arm64_linux:   "31e7eda3b2d0a486f421f8fe5fee2766bde3f8443dcbcf5264b8ef8d92cf0a11"
    sha256               x86_64_linux:  "8188f01532060795dcbfe4825fa63cefb4510d2dac9ffdf5e5b33ea986d6e426"
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
