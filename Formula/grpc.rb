class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.17.0.tar.gz"
  sha256 "d98d41399783c8f9f0cd8d8fec3920c8378d3a77ec4b7bdf228832cac4ab8617"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "8a112c44bf3294a431a75da1ef4c9a0eb8a7b50163d9e21dcc4c27c5085e3274" => :mojave
    sha256 "3e1152afd018d77c2156c0a04c813308721a7e1eaf947fab5f623ec4988dda69" => :high_sierra
    sha256 "69454dbee692aede0900eda76570cbbc105ae3c92181f28a59c86a3c4b708805" => :sierra
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
