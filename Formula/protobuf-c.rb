class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.3/protobuf-c-1.3.3.tar.gz"
  sha256 "22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78"
  license "BSD-2-Clause"
  revision 3

  bottle do
    cellar :any
    sha256 "46ef6efc7d7309d8113f80d831cf865f28481faf251de50984dcca476dcf1fb4" => :big_sur
    sha256 "56b5ae07f34ef446e3c126ab2c4a012e25419f70222ca4b6460c1845a9d2ad93" => :arm64_big_sur
    sha256 "13aee041a8a45ef37fda07f93e8e968c3e0ec9673ef0bd03d8567659e9ef51a7" => :catalina
    sha256 "443fbef1ad64772129c7f725e016a022046ea74c6db91056fbf19b48816e9cae" => :mojave
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
