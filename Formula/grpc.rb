class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.4.tar.gz"
  sha256 "9da621f79f6369f674d6e4091d4e3a4ec8a62ca2a4ab6d9152081934a10aa271"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "431238f006410104081438614b883ba11684c2049504c26d60f4ee5155706ab3" => :high_sierra
    sha256 "11b217e3992cf102f824e7831ae442c137d4febc7eae6ae8cbde04846fd79d70" => :sierra
    sha256 "e827984d6a6a2640f2b386d44018961b5f18e7be3c0044f301165383f1b0784f" => :el_capitan
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
