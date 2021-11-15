class Jthread < Formula
  desc "C++ class to make use of threads easy"
  homepage "https://research.edm.uhasselt.be/jori/page/CS/Jthread.html"
  url "https://research.edm.uhasselt.be/jori/jthread/jthread-1.3.3.tar.bz2"
  sha256 "17560e8f63fa4df11c3712a304ded85870227b2710a2f39692133d354ea0b64f"

  livecheck do
    url :homepage
    regex(/href=.*?jthread[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a786a2608afa79835cab95860405402c716916bb2f79b5e562c838269e178b4"
    sha256 cellar: :any,                 arm64_big_sur:  "12a85b410fa6b4c3e47e518813e0907b09ea01ed917ecb39354488ba1afb8ee8"
    sha256 cellar: :any,                 monterey:       "9c27b5547869cf439f7d5fa99b8bc7de3931f3ea73d113e14d1ad013dbb189d8"
    sha256 cellar: :any,                 big_sur:        "8932e35ce2fd13b2ba082af71db656adc9c9413280b279067773ceea8542dc3b"
    sha256 cellar: :any,                 catalina:       "e228f81df252c35872df1c6e0711857ad7a7312aae17304a7bcefa0905106b61"
    sha256 cellar: :any,                 mojave:         "e2dcd37c6dbeda04e3a9408d9f09f8d00ff669a3eb7ee8b098742887d800162e"
    sha256 cellar: :any,                 high_sierra:    "2d9c8a2d9e52f9419cd1015d982e06d58963e29c43a44f7ddfbbf6f149e20cc0"
    sha256 cellar: :any,                 sierra:         "099b841458d4d6f4ac3f5e7b453d4ec5b2a50f4dd1a6ccac9614ac72a1c1c90f"
    sha256 cellar: :any,                 el_capitan:     "0e846e47e0350f6dc4ca15f5eb6f9e9d2cf7345c115476bc93fc78ac2cb056af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0288eb31c63b100814238cd97f4fb9ac7e26fde1bd284b2dfacee67df8de337f"
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
