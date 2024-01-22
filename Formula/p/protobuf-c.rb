class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8e7652cd194d83b5717f448cbc78a6d1afa0ad02b5c2e9307005696a16e59fa"
    sha256 cellar: :any,                 arm64_ventura:  "838c1abe3e7565fef11a8fedbde7e3d6d3aff4b525a06e1b8b6ac83ffc0f9c58"
    sha256 cellar: :any,                 arm64_monterey: "b12dae9ceafdbccc96467b44d9a4e5f3b9b8a2b1d0350a64c49e6d2514a8e0d7"
    sha256 cellar: :any,                 sonoma:         "174cb4863053695427d6e2474fd155dd39fe460892c956390f079e5e3a88c962"
    sha256 cellar: :any,                 ventura:        "a080fd006233c5d48c4b9016ecc124cfd3d3994597f4b9c2a0dbd9d1b26bef42"
    sha256 cellar: :any,                 monterey:       "12772179124dad1441a0786b24717ed32f5afe533429ddd380037ad99360f2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4914b0f3f1663e0cf40d163c3136e60c19d0eab9275d1b49813413902980d627"
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
