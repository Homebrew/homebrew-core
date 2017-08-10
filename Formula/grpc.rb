class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.4.tar.gz"
  sha256 "fc678678f34fc6069c7aacbaa20e067529246ce3145f3b54ecddfcc876a27b8c"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "b46ddb9e639229370effdf5b376b7cee289165997d4e95fae7fb152442602d45" => :sierra
    sha256 "5d6ceefa1fdc21dc284589e1e98796f28b8240d0a9b69e5683833a086f9fe94d" => :el_capitan
    sha256 "a2e77bbb576c81fa60248e4e4e4ffa1c7542c765a6ec6cbcf117e2af5c895b1f" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
