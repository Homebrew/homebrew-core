class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.0.tar.gz"
  sha256 "2a758d1bed51760bbd57fcaa00610534e0cc3a6d55d91983724e5f46739d66b8"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "54376ef52c7368bdf496274148185c317d5afd99d11504aece81ca4468a2140a" => :high_sierra
    sha256 "fc4ff68bca0257330b92d22c2219066ec3f6a7fe3561649b088c9846ef7cf03e" => :sierra
    sha256 "0989cb076d13ab1d40a0a581ab56f0891a469de25219677a1f9323b89e728f2d" => :el_capitan
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
