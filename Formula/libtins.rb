class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v3.5.tar.gz"
  sha256 "1b0624b2eea3ce077a86f3abd3e625661760c4cfd21cd8f3d3cd3622229ff2cd"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "01be883bfd9b9c2d11c26b47b768bdc22ff697d571d6369587298ccaa9b8ffb2" => :sierra
    sha256 "b86f82447dcdb290967bcdb7728eaad65c418819418689bcaedee9f682bbec3b" => :el_capitan
    sha256 "9a42acca6942a7414fd8625f9519f20e1c56cf465b13ddbf69da929c3d728187" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args
    args << "-DLIBTINS_ENABLE_CXX11=1" if build.cxx11?

    system "cmake", ".", *args
    system "make", "install"
    doc.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-ltins", "-o", "test"
  end
end
