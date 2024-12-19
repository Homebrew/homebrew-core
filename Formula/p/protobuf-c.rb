class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 15

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d38b169b6c2b04669a57ca1537cbc83c0f3c66f80a95126f946b3aec7bb4229a"
    sha256 cellar: :any,                 arm64_sonoma:  "1fb150959c6a5a3ce0b208ba098b8b4bdcba30d831dd191e0f2e45652801fa7a"
    sha256 cellar: :any,                 arm64_ventura: "b246e691eca83ecd1b72d192be11a3849a39946cecfbf4c4df2eabd22f895c59"
    sha256 cellar: :any,                 sonoma:        "e1e32fdd0e6e73f7fa8d54d7aebf205b9fd45b5b3e3c68c118844bc16e705186"
    sha256 cellar: :any,                 ventura:       "4515085ca47c21f8a3bb6f86b6179893247cda495c8058d0ed38c17641763ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2936f5cda9e189ebe6b81d56b15a041f9d791d2621aa8b62c3e6832d875195f6"
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
