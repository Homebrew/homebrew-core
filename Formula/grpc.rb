class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.25.0.tar.gz"
  sha256 "ffbe61269160ea745e487f79b0fd06b6edd3d50c6d9123f053b5634737cf2f69"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "95d0cc6709f6a4465e9580937db5fd9a45812cf084f0689c71b69666a5bfd65b" => :catalina
    sha256 "6cc94b6a248af3cd10daa68b732142de4a1a5d4e5b2eaa73fb7bd537fe57cfc7" => :mojave
    sha256 "fc1760f5aa11cb91f4d535fb0c236197be7406bcab0caf7d5607a829a58a9c8a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
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
