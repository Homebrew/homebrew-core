class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.1.4.tar.gz"
  sha256 "45ab5bdfa90ea41b17d4d81edbadcff303158b7cccdf9d7ea196ca9e104b214c"
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "da75e9100d176ec3933f651ea13de2028dfe315934ce549bf40101d0fc29d17d" => :sierra
    sha256 "c8a35517d50636b96be79a64e4eed60c14fc3a4ec8b3091908b3a3a93c377c0a" => :el_capitan
    sha256 "a038ccd59482d632e80bf22d9c5d54a45eae8f41473d6ee709ba8fba143062d5" => :yosemite
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
