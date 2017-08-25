class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.6.tar.gz"
  sha256 "041e529a0eef5de3d427a61fcba6a46e8450f1e624a0fc9dbe263395ea100e06"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "d169c35f531ad2b4ed9fc7fe0adc04f1a8c4db2d1ef80fdbc9e558b6e8c3b81b" => :sierra
    sha256 "b0ce37774bf78b64ae3520559797239afc261bd490c4057ce71b8b2b4e537d71" => :el_capitan
    sha256 "30fc758b967fabf4f71f5045415216ece303ad3fffebddec823aeecf281dd8e1" => :yosemite
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
