class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.23.0.tar.gz"
  sha256 "f56ced18740895b943418fa29575a65cc2396ccfa3159fa40d318ef5f59471f9"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "dda9cf2ed008eb20bebc132f8416e218845e96aeba7948c04dbc306e5af13017" => :mojave
    sha256 "718c36e219969cd6609431b01535dd51778ccf768f32ca615325d0253e72d7f0" => :high_sierra
    sha256 "cf647b7f7539b6a4a2308d7742183a728343b88292c8f04f8a40769f1776509e" => :sierra
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
