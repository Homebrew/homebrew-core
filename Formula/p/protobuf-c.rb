class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b93c1f49a901ea16b5bfacaf5a10f9bd4f09c295c5f1795f080be6fe7faad5a5"
    sha256 cellar: :any,                 arm64_ventura:  "e731a68e108cd354a43c6d3aa29f67f393372221349d3efeb401f7ebaca990bf"
    sha256 cellar: :any,                 arm64_monterey: "951d1564c87b5597dd143f8aa50706dcf0ce6e60bd2cd487b7a68ed00155efc0"
    sha256 cellar: :any,                 sonoma:         "2d707548d7efcd1db02820483202daf39441bd0a3ef482a487668cf050dce999"
    sha256 cellar: :any,                 ventura:        "97ecf11df5a5c6aecbbecddedecb5e2ec10753fabb43831142b674d8874b8746"
    sha256 cellar: :any,                 monterey:       "0f6e11df495a6c210758c78940ce102f9e93b4410843bb5424e62dc53fb2ea2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5c30f7a107018873e0f026f04de1d3c10fe04ae85e631231235c6e77d8eae4"
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
