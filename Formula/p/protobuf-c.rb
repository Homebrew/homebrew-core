class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d41d8e2810be2c6b407858cfcdc388bd50b6e876520090202883d38c6cf922a9"
    sha256 cellar: :any,                 arm64_sonoma:  "3972558e6edf7738eebbb771f17bedb7edd69f0a06352d68741c576bda6414c9"
    sha256 cellar: :any,                 arm64_ventura: "365b1a39a08002c87ab523e8f24b5fcf2aa00c12cc2308093b54ab17681e96f4"
    sha256 cellar: :any,                 sonoma:        "412a5685c185e124c29e63d45c06413670da2cf8f87041b12b78e4814b813c94"
    sha256 cellar: :any,                 ventura:       "d00b15e374af0308b1cf81405cb206d0a16f98f8dc70a441022503c2f282c544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0546972473388485cbf82ecc77939ce6680544a00f65f7e254ebe01fa01252ac"
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
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end
