class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "626106ff116a51b04fa2c2cd36c742bd0fa596597b8673bad8e0de053a2b5d98"
    sha256 cellar: :any,                 arm64_ventura:  "d737e93aac2b0359d19debceb053bcfcd7825ed6ed07faccf094417dc26df46a"
    sha256 cellar: :any,                 arm64_monterey: "397f5064d4e1a75843be44cd2c160b793834993536b2bf7a19cfcd7c7036aca1"
    sha256 cellar: :any,                 sonoma:         "c41774a8276efd7814b4f836713e5238a9edf0ff003914152be166c60bde014e"
    sha256 cellar: :any,                 ventura:        "adbe9cd183d279b2880738a18838bbededf4d2023b76b8e554ace649788ae262"
    sha256 cellar: :any,                 monterey:       "752d7fcb9214ce1de147f00ea1a7771a2ae8c55957271edd97ca088da86af163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c80b6b3e0f47806635a9f37e2a202ff552c4f8dde81d3406fb3dcfda7c1402"
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
