class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.0/protobuf-c-1.4.0.tar.gz"
  sha256 "26d98ee9bf18a6eba0d3f855ddec31dbe857667d269bc0b6017335572f85bbcb"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4a3986d128583d41b29e369bfddeff1e369267441797b71776b8567b4eac5702"
    sha256 cellar: :any,                 arm64_big_sur:  "8e855e301d3e6f20acb9b79f8e86ed46cba43790d03a2a82b2de7024abb721ec"
    sha256 cellar: :any,                 monterey:       "1d380b543cfaed179de2a482212975c9bc7219da96aa939148f9c6a6a30e170c"
    sha256 cellar: :any,                 big_sur:        "c89d06a0c0b555379f137f448cd8d25dd0a476d417ab277c572fd07c6faf0275"
    sha256 cellar: :any,                 catalina:       "55732600c0f049e6b40bee2751dfacaadd79d62a72f6f843897e25d129cbd47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52bfbd47abd15484c307ae0e9d11d93bf9c98606dabaa893b75952e9db80a28"
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.cxx11

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
