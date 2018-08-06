class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.14.0.tar.gz"
  sha256 "ad7686301cf828e2119c66571031bd8d18f93240ae05d81adaa279e1cc91c301"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "0afc6fa16339917ed4458e0b5c10f943bd4267722793a69286d35b7a237dbf44" => :high_sierra
    sha256 "df1214fdcd443fc05749c1528d3985d4c9fadfc2d55277181fd90ea604bb82fc" => :sierra
    sha256 "21f88c0cbeafd4066acbec151e820a7a7de2662f1fce238ed1d68b26d07d32b3" => :el_capitan
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
