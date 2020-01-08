class Jthread < Formula
  desc "C++ class to make use of threads easy"
  homepage "https://research.edm.uhasselt.be/jori/jthread"
  url "https://research.edm.uhasselt.be/jori/jthread/jthread-1.3.3.tar.bz2"
  sha256 "17560e8f63fa4df11c3712a304ded85870227b2710a2f39692133d354ea0b64f"

  bottle do
    cellar :any
    sha256 "e228f81df252c35872df1c6e0711857ad7a7312aae17304a7bcefa0905106b61" => :catalina
    sha256 "e2dcd37c6dbeda04e3a9408d9f09f8d00ff669a3eb7ee8b098742887d800162e" => :mojave
    sha256 "2d9c8a2d9e52f9419cd1015d982e06d58963e29c43a44f7ddfbbf6f149e20cc0" => :high_sierra
    sha256 "099b841458d4d6f4ac3f5e7b453d4ec5b2a50f4dd1a6ccac9614ac72a1c1c90f" => :sierra
    sha256 "0e846e47e0350f6dc4ca15f5eb6f9e9d2cf7345c115476bc93fc78ac2cb056af" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <jthread/jthread.h>
      using namespace jthread;

      int main() {
        JMutex* jm = new JMutex();
        jm->Init();
        jm->Lock();
        jm->Unlock();
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ljthread",
                    "-o", "test"
    system "./test"
  end
end
