class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.0/protobuf-c-1.4.0.tar.gz"
  sha256 "26d98ee9bf18a6eba0d3f855ddec31dbe857667d269bc0b6017335572f85bbcb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26abd73290938018b40214fbf1d76dba12f9fa5d96bcd51aa719e1793eb0c366"
    sha256 cellar: :any,                 arm64_big_sur:  "1ca90f4286b3c7210aeb15ba9ce34c09972806c1477f40dbd2e7b3bafcdbb275"
    sha256 cellar: :any,                 monterey:       "5948d96ab2e7476bfab2ca0fe18ae8bdb876ef06cff93664f6faae8735b250c0"
    sha256 cellar: :any,                 big_sur:        "a79fd80a8a0fb8dd05a014cc34ac7281441c167659c0bf1ea36df7be8db3084b"
    sha256 cellar: :any,                 catalina:       "4caae0df2e6727218460e8ef1a0cf18aa0bee6fd14841e6f3456fa325faf4326"
    sha256 cellar: :any,                 mojave:         "96cf2cab8b8b7e5e8228fb5c6bf9bfdd34c7b54ab208eda056ace3648600777a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adfaa9b5233ac90599f13933525f2e12fcaab3b1099aa8fc80eac7580c6b3ce5"
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
