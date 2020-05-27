class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.29.1",
    :revision => "7d89dbb311f049b43bda7bbf6f7d7bf1b4c24419",
    :shallow  => false
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "c96ba02fd205cb9dfa8dfc90d2b76c7e78fd361b6c0cc627d824926c62d4f7e5" => :catalina
    sha256 "38b16768396deae0813d4eb3d903cf227023776583b5cc95fe46e0150eb59707" => :mojave
    sha256 "3b27b761aa04fa300d42b223a32fbd53b72466a2c1f27d87650c2c3780725d58" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
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
