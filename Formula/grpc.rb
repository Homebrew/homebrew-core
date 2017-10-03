class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.6.5.tar.gz"
  sha256 "939e686dc5b6221f959b839df0987fa9eda08ba8d72530ff7946d7226c2cb5ea"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "0df93013d678537b7203c0cde67197f5f233a59ecf5293daf575595efee068b2" => :high_sierra
    sha256 "b9f4d1d2eec8ab79cac3eb2fddd7a206d245eea0bf85c940666f2790732d2ce0" => :sierra
    sha256 "9408dc98f1abccc097fb17417daca1652f66c68df65e3cba78a4dc5e895d9d6d" => :el_capitan
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
