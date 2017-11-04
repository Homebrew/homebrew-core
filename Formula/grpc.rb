class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  head "https://github.com/grpc/grpc.git"

  stable do
    url "https://github.com/grpc/grpc/archive/v1.7.1.tar.gz"
    sha256 "6b2bb798652ce5758130f62cbd31b9ce6e453dd1e59b710edf6ca0261c6db077"
  end

  bottle do
    sha256 "6a5c18584c79c72376a976dac256558f6f4217c9ce852aac53d46342581db575" => :high_sierra
    sha256 "cdee88720146ca4854126adf19981c8f53fde2286103327f71702e2b7fab64a6" => :sierra
    sha256 "22f0bb317c166c5bb076debbec4b78560b869051fff07daa7a25e28e93d6cc95" => :el_capitan
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
