class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.21.1.tar.gz"
  sha256 "1bf082fb3016154d3f806da8eb5876caf05743da4b2e8130fadd000df74b5bb6"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "14767163457d692bc8671b13dd7597e567f040bff08e02e6dcfea026619b8b23" => :mojave
    sha256 "db7d11bbc9c28ea81d1bab456790ee94e5b165cbe7ac4bb63146861f0ad1e9d8" => :high_sierra
    sha256 "58e9b5d34ce4d3cc7ced6cd980b14d921971defb2c38983b7dc3e9060ea79d0d" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
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
