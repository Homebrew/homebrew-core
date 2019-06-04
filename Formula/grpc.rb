class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.21.3.tar.gz"
  sha256 "50747c8939c535b1059f19534de263eb9b7570b5347390fb24b0bbce8763e9a4"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "3b07deab43987b05290d5304822c950ebd5d61b2d4f4b9af2bd3a981fc794664" => :mojave
    sha256 "6416af23431fbae1985d07e075bb7e931add9297d31246eea14a6abe8170f603" => :high_sierra
    sha256 "21e4db37ac311784e3516d20ac915ce10d74986d5e5fc70c78423902dfd4476a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
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
