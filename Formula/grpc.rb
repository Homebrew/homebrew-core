class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.8.3.tar.gz"
  sha256 "c14bceddc6475a09927a815811a8161cdfa7acb445262835da6bc24da9842c92"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "d4eb14187b27c3c22bfb65294a96760e5e556440a34a4eb0571508b606a87a5e" => :high_sierra
    sha256 "4e32489931c7345e3d28a54bd634c20818c0e61f1439a3cfb4b18710299f215a" => :sierra
    sha256 "0fa325aba67f3bf9a7351c71e5fe18ac532fe08139c285cec364e82e28c5f197" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "gflags"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
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
