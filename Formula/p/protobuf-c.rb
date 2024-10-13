class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "904d4a38259359584125cd475f570d2e8af6b0f9b18e4ea462dc78fc1c407a8d"
    sha256 cellar: :any,                 arm64_sonoma:  "18e1db05a6041d908ba135a63d35b84773a652fa60dcfaa4b059b08660ea6067"
    sha256 cellar: :any,                 arm64_ventura: "0e5cd82d7399ac39694c18ee938ebf842aae03ceca1a8b0988f10ead5426bb3b"
    sha256 cellar: :any,                 sonoma:        "675017f43f47c1d80bebdc4e1cc70c380ee79446584f17ff9b942ae7ebaa4389"
    sha256 cellar: :any,                 ventura:       "7d88260630f2b33fd996c1118244222d5cb49217ac6fb283f852eb0358369b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c9008f778cd4eac99c84d861c184be9f7a2b62ab5bcc382f7d9f49045e000bf"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
