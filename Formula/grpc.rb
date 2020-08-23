class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    tag:      "v1.30.2",
    revision: "de6defa6fff08de20e36f9168f5b277e292daf46",
    shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "19bbcb825bfd65ec65bfb7a2750f5ad828bf74c1287c5684bbf13a1c188e7cc4" => :catalina
    sha256 "92f88af6c076c6511938565ed7ab786da4417027ff12936f82de327d7a66d671" => :mojave
    sha256 "77551361ecc61e5aa21839413a27a298ee849cfd12c7d90a20048f8c1c58c637" => :high_sierra
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
