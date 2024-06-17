class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bfaa784b4d53fa651f77e1e0831ead7ef13821cf6f60b85ff8a4c437ed08581"
    sha256 cellar: :any,                 arm64_ventura:  "b6926059456cb0b142f4cee8a274fd5dc879ba1d5b871d1da654e0804f2ca44e"
    sha256 cellar: :any,                 arm64_monterey: "1261907232a1e7076bed65fbd057d224d3ca2dbfad9dd0da5a0706acfe17a97e"
    sha256 cellar: :any,                 sonoma:         "7c6ec8a41a31cceb809a6ba5f7469aa1c1149906ece527a01789a1e9a032d2ab"
    sha256 cellar: :any,                 ventura:        "022668ca2cf5084406c83d97b10d4c49a3f557e00e24fa56739638aa8717351b"
    sha256 cellar: :any,                 monterey:       "c4683cb3f5f90277c519c7ca985d1e1736cb4b7e39ae107b62719be282e6e11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576ae613de3be18739dabf8b7ad01d0954594a2ca1e4e4b046535309161dea6b"
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
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/d95aced22df60a2f0049fc03af48c8b02ce4d474.patch?full_index=1"
    sha256 "7aa44807367a4547bd15b3aa9a5275d5fe4739348bf2741ca773fa47015fb01a"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

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
  end
end
