class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.23.0.tar.gz"
  sha256 "f56ced18740895b943418fa29575a65cc2396ccfa3159fa40d318ef5f59471f9"
  revision 3
  head "https://github.com/grpc/grpc.git"

  bottle do
    rebuild 1
    sha256 "4fef8b89eb38cb92d5195efeed653cc1a50ca4ca2f3253b47b4bdcbcbd31bcbe" => :mojave
    sha256 "b78d057cb6c7c925bb153a324e409a02629650942fe2149c7bc80155b03698b0" => :high_sierra
    sha256 "992a0173702a02cb70f2044a11c173fd3c7517c91824c81e1bbe029bac6c2395" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
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
