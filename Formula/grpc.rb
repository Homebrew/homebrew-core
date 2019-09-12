class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.23.0.tar.gz"
  sha256 "f56ced18740895b943418fa29575a65cc2396ccfa3159fa40d318ef5f59471f9"
  revision 2
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "f309a1e9a1e08e457dbb70973719ed233d7f29be0feb71ab9d8ccb5721f6098d" => :mojave
    sha256 "9e299a4e8d2d9037176fc76830da89e864ee85983e0d9f667dbca097413b6f83" => :high_sierra
    sha256 "df36c17fba564edd1f2d6b151e5387afa378db872f0d798b530dbda1169dd1df" => :sierra
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
