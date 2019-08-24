class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.23.0.tar.gz"
  sha256 "f56ced18740895b943418fa29575a65cc2396ccfa3159fa40d318ef5f59471f9"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "16eae9c529ef9774177033b629b63aab43f448a96651b09cfa7f32bddba19f79" => :mojave
    sha256 "a3dacc4c354917ebee2ab7a31581eef42d9010ece15745096bd831b32eefc667" => :high_sierra
    sha256 "01eed990858531f8235758dd16ce6a61c7a37a43522804470f8de441f915a3a2" => :sierra
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
