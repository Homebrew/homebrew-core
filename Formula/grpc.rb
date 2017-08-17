class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.4.6.tar.gz"
  sha256 "041e529a0eef5de3d427a61fcba6a46e8450f1e624a0fc9dbe263395ea100e06"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "3184cc406fed0c45de09cb96bb6bade3ba9b939bbd9977bb62a3b9f90bdc232c" => :sierra
    sha256 "8d4f2bd752d43495d8b4e4430972a789a04bfa157a30287b9b6fc0d16f591474" => :el_capitan
    sha256 "5705620e9c81b3689e0391c62a2a4f5cbe046c20eb8e73dd337d39b60b132b5f" => :yosemite
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
