class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7faeb770aed57e27102f2376d93ae7e82834d3dc672bdea3eeebe50354d800e9"
    sha256 cellar: :any,                 arm64_monterey: "0fea195abfb08ff10fc8faf4a0fd286941f0c369d951ba20b7457290ae8f4286"
    sha256 cellar: :any,                 arm64_big_sur:  "6dbb3f8ed1db69f358fdd832d757c169883263ba5d756d1423ac0c826fa9a49e"
    sha256 cellar: :any,                 ventura:        "d362d2c2f4aff740a5ac295916fcf8782b2067c9aa293c2ee849e6d1abbd42c2"
    sha256 cellar: :any,                 monterey:       "8573b374486e464c8da48089d5ace6a0eda71405040acc555dc89b54466263ab"
    sha256 cellar: :any,                 big_sur:        "8b022f6ff09f41d5ca48781fbe0168ba6420ffe4d24be3bb00d4256ab344f098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cbaee2214be0208918ae530369e455627e6f7ffe8cb3f9f662ff78131be7ed"
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf@21" # https://github.com/protobuf-c/protobuf-c/issues/544

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
    system Formula["protobuf@21"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
