class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.30.2",
    :revision => "de6defa6fff08de20e36f9168f5b277e292daf46",
    :shallow  => false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "6ee1f9594fa9d4adb361f2da9059c419c9fca791b676f03bccdd5d118fefee5b" => :catalina
    sha256 "256a919aade45c1d541bff5bb3717e3c05e6fff3b03a16c9d2f78d1a8f5dc5d9" => :mojave
    sha256 "abab69a30012dbb80c111ef73909edf75239451fda751c311e673893ef9eed8d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
