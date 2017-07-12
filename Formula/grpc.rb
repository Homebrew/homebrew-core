class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.2.tar.gz"
  sha256 "268481b9cd09aaa0758fcd14236537cbd3ebcd637f43150fdf7937582f2dc4dc"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "1af8ade005e6145d2f69af277c6211c56b8a397cd3b6e841e24a2cb27e909d28" => :sierra
    sha256 "4be794dee235dfe5906bb40e5fa5a75c47e929106bdd04402d268ded54fefcb2" => :el_capitan
    sha256 "6d41dbe232e902261a289afc58d387017562259f7d096549b1f8b9b80829dd7d" => :yosemite
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
