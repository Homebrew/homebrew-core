class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46202d08682f502230220a3fa472d79168dc701354841e99379723b9cd600d2c"
    sha256 cellar: :any,                 arm64_ventura:  "1c1ec792cc547a8b0c498f94b0ffc72d37252bccbd065602519913efe1b89a32"
    sha256 cellar: :any,                 arm64_monterey: "5084fac390c5530ef7687675af3d70a1e3701562673b357c94a59ed6b6fb2c59"
    sha256 cellar: :any,                 sonoma:         "f763b9c45a524c3a8ffd7425476c334cd7dbdbd689b135e802155aae11027f02"
    sha256 cellar: :any,                 ventura:        "b36607c4ec9e3100454f0f113e01933a44e385a2cc023c9020cc8822b3c3b32d"
    sha256 cellar: :any,                 monterey:       "023d835446a4a5343d9454ac4bd832cb66aaf73d7f991cad28fcc41ec2c7f12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50cf4c92da67b310f341fcd6db33c5c88a168a0004354ad313e2cd05aea08a5a"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
