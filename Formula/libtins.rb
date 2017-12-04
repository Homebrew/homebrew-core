class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.0.tar.gz"
  sha256 "2a758d1bed51760bbd57fcaa00610534e0cc3a6d55d91983724e5f46739d66b8"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "36413e6fccbe2d790e224c4673f103a350973bf1832d4e241faa13e5ac7c998f" => :high_sierra
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
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
