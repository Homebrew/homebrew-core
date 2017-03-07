class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.1.4.tar.gz"
  sha256 "45ab5bdfa90ea41b17d4d81edbadcff303158b7cccdf9d7ea196ca9e104b214c"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "8fbabe0b1c7dd1b4ad29828c8f36683c8f424369f4f963caa607750a0512c3cb" => :sierra
    sha256 "b468654d964c6e445d68e7dcac80da486f4319c45a4e7bb1ac23d50c716800db" => :el_capitan
    sha256 "742be127a6ce2f9f6e9542e4fd7804a8464edcedd5a8e1e96a6be894c9bf3c13" => :yosemite
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
