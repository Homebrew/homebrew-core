class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.3.2.tar.gz"
  sha256 "6228fb43e6b11b1dec5aa21e66482bb45013b45cb70c1ca062f4848469d1ab99"
  revision 1
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "f49858b2fae9b13494084181b34939ed9920e99f3e1739446b95dc3516c1168c" => :sierra
    sha256 "5b4f548418f3cbd7c1eabe95d33041f7e8c0ecc07ea62b87a8e6c71e3eb935f8" => :el_capitan
    sha256 "9ede8a74e121aae5516fb35a84b980c402a71d9fe1338707782a40326f49cd3b" => :yosemite
  end

  option "with-tools", "Build tools"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "gflags" if build.with? "tools"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    if build.with? "tools"
      (buildpath/"third_party/googletest").install resource("gtest")
      system "make", "grpc_cli", "prefix=#{prefix}"
      bin.install "bins/opt/grpc_cli"
    end
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
