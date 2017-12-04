class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.3.tar.gz"
  sha256 "13776667743cf6e3df36bcf4f8c7ac828859ce02c9988514e3fdddc3efba98f7"

  bottle do
    cellar :any
    sha256 "08c235e9351b64387741f30f34f71483fd78743cd62e339b5a62266e72be2d15" => :high_sierra
    sha256 "b79fe900621465bf9af18a442b8691e14bf89e45b3e0088b2c84666db774efc7" => :sierra
    sha256 "da7197eb5d23c53de167ea9e892a5cbc1e8781ae9f3909ffd23d08c2dfb60158" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lebur128", "-o", "test"
    system "./test"
  end
end
