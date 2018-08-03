class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.14.0.tar.gz"
  sha256 "ad7686301cf828e2119c66571031bd8d18f93240ae05d81adaa279e1cc91c301"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "6f8a195aaeb2a6b3c2d589a63e0c400d409c85dca3f3e2de7eba68de659637e2" => :high_sierra
    sha256 "5b05b324c5c5660777e7a47d991d73e4dc01a951009cd9849fbdab9dcae92f74" => :sierra
    sha256 "383ad6e4de4f1b7dbfbd4aac05d8e6bb25176ca5203a73a217acf38592f129c6" => :el_capitan
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
