class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.20.1.tar.gz"
  sha256 "ba8b08a697b66e14af35da07753583cf32ff3d14dcd768f91b1bbe2e6c07c349"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "f30095aecbd9ab4754292c9aade2e8d0e0705b86211157a0d44c95c1b5476037" => :mojave
    sha256 "310aef9b989417cda8fae23bb3d5de5672020468dc94979c2641cc7b77347420" => :high_sierra
    sha256 "b5230e7c6349b106084c6fc24c1ce8a2f8f4a5872b22ddcd363a30ac278675a0" => :sierra
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
