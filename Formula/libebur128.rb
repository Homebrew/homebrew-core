class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.2.tar.gz"
  sha256 "1d0d7e855da04010a2432e11fbc596502caf11b61c3b571ccbcb10095fe44b43"

  bottle do
    cellar :any
    sha256 "1a7fa4b2adf725cf97da6c8957057310e74577100890d02ee1a041733c3e8b64" => :sierra
    sha256 "2412f594c70dc280d8aa912d13e5254d975b467aaff3c6127eea9c0d540d254f" => :el_capitan
    sha256 "28a1a3d560d6f0641cddc5f4df2bc17b205a7b6c625aaadf609ad06d4743bf50" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lebur128", "-o", "test"
    system "./test"
  end
end
