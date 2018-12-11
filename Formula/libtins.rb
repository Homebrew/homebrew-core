class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.1.tar.gz"
  sha256 "81a0ae1e04499b25984b2833579d33c4a78ff4513e9a14176c574e855163f7a5"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "794c7d9d7c59e9e62381074f8a517f946f2181d095f7350f495a11fcd3c1ac30" => :mojave
    sha256 "076cab953c8bee72606674f03ae733eafca8e4714bef54f0b32b75638896f2ea" => :high_sierra
    sha256 "21368242645edc0a8cace9e9b0161b4ae94338e358a8ff365b831a7bf150916a" => :sierra
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
