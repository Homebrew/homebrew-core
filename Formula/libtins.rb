class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.1.tar.gz"
  sha256 "81a0ae1e04499b25984b2833579d33c4a78ff4513e9a14176c574e855163f7a5"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "a791763b7a15df9523bf83f8bf15999181e026b4e146b78247ff7ab185ecc380" => :mojave
    sha256 "54376ef52c7368bdf496274148185c317d5afd99d11504aece81ca4468a2140a" => :high_sierra
    sha256 "fc4ff68bca0257330b92d22c2219066ec3f6a7fe3561649b088c9846ef7cf03e" => :sierra
    sha256 "0989cb076d13ab1d40a0a581ab56f0891a469de25219677a1f9323b89e728f2d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
