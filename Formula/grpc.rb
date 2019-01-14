class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.17.2.tar.gz"
  sha256 "34ed95b727e7c6fcbf85e5eb422e962788e21707b712fdb4caf931553c2c6dbc"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "8dff22d6238c31089b8ca51e572e36a9cb4bf9fc556c6aea656de8ccb724fd10" => :mojave
    sha256 "905ef59111a7fef094aa3391c451b2a71aa68eb9a3ae00e148560a787c8ba5af" => :high_sierra
    sha256 "2c73ad06745f8802f7baae1fbdeaac8c7bd51920a187c481d26e1de82b58deac" => :sierra
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
