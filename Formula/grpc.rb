class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.28.0",
    :revision => "c5789be22cada39b80d70d4ace3738d62f1c0a04",
    :shallow  => false
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "fa2e5c88428afa430740568e0513f94a9acc85a5536455ee9a72cbfc2ab9c830" => :catalina
    sha256 "a55d2205d7877dfae54869fab6be4fd6fe5ed22f309064179d5a72fb3d50af1e" => :mojave
    sha256 "205c61401c7e3bf11c0a23edbe4fcde77ae6e81a5075f26e4a45ab8aa263be82" => :high_sierra
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
