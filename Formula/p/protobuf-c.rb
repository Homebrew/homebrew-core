class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e126a9b3a7187dd6d62c635505b284c9bf15375f76f53e8fcb37b4864a9d4606"
    sha256 cellar: :any,                 arm64_sonoma:  "ebfe8527faeef9424fc49ece715eb37648789eaf39bb6d46b9f57b17fdc88af7"
    sha256 cellar: :any,                 arm64_ventura: "bb0ad5bef5a788dd56b3472bc3f8c62879c483c786b9a3a3c9ea61be5d5486a5"
    sha256 cellar: :any,                 sonoma:        "a0db027a6bc9d54bd10f0bfa47ff2fb4ad0fcf4efd4ecf0f1243651dc8d84a49"
    sha256 cellar: :any,                 ventura:       "ba6edb598c82c195302f320fc934ffc3e640b89744c93ec96fe8c8f64ea5aeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79036e60276199da3118381a3b616b125e1a17d3a8b8f43a9c12d0f905f861a"
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

  # Apply commits from open PR to support Protobuf 26.
  # PR ref: https://github.com/protobuf-c/protobuf-c/pull/711
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/e3acc96ca2a00ef715fa2caa659f677cad8a9fa0.patch?full_index=1"
    sha256 "3b564a971023d127bb7b666e5669f792c94766836ccaed5acfae3e23b8152d43"
  end
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/1b4b205d87b1bc6f575db1fd1cbbb334a694abe8.patch?full_index=1"
    sha256 "6d02812445a229963add1b41c07bebddc3437fecb2a03844708512326fd70914"
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
