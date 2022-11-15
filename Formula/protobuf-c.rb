class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "51daa29261e512d3a61089e74942c0d085f6bbccfbf8c4e8828856344b797fb2"
    sha256 cellar: :any,                 arm64_monterey: "201a08aabe9bc83897b908019d7dd8aba6dcddf46224eb15bbccdd5f70f6a21b"
    sha256 cellar: :any,                 arm64_big_sur:  "48ea3989f31b6f44c8170479f5115064ed32ccd4ccf6784ea4ad254697d4f53e"
    sha256 cellar: :any,                 ventura:        "06eadf1c5ac5bcc4eb1416751163864d7724a4c77703540cde2f9f31ad26a452"
    sha256 cellar: :any,                 monterey:       "eeb51fce7f9a32e9c64ed31ffaa0c9e1fe747b0e047065fcd7e69cc6361b039c"
    sha256 cellar: :any,                 big_sur:        "06b3fc06f5fe8b09353ac6aa106373833d897a960bb607a6caf84ba0043634ac"
    sha256 cellar: :any,                 catalina:       "5c3d841771a3527b3c118abb738b2ab04345de884588cf313d8ed14fe8514288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd6aa2c3972f3b24248fb0a75638c61dc658cd0c2bc3005b088715e68f6a106"
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

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
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
