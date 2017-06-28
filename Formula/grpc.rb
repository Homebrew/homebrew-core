class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.1.tar.gz"
  sha256 "60840ef0e9b71f47cb73d4e220089b3d1e78dbfa011ae128f7688622f287b543"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "45b4a3636caebe80e77bf13ab56156c278b16e787cceb21282defdadbf728001" => :sierra
    sha256 "78158b094263e2b11a51c0f39c18a77bf091861efa77aeb4f80d2331c869fcf4" => :el_capitan
    sha256 "43568dfab0c9a996482cb47c8588171c299e0b58eac5435b1f620784749778eb" => :yosemite
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
