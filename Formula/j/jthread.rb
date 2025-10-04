class Jthread < Formula
  desc "C++ class to make use of threads easy"
  homepage "https://research.edm.uhasselt.be/jori/page/CS/Jthread.html"
  url "https://research.edm.uhasselt.be/jori/jthread/jthread-1.3.3.tar.bz2"
  sha256 "17560e8f63fa4df11c3712a304ded85870227b2710a2f39692133d354ea0b64f"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?jthread[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6afeed9e7aae5a7268e9361ab770bc8b477a4e3752043ab2ece66a38eb589be6"
    sha256 cellar: :any,                 arm64_sequoia:  "0b2a1b4160a03bae62a73f61bd3e2bbedd3a4080f4e2650060a05bb445301c4b"
    sha256 cellar: :any,                 arm64_sonoma:   "4cbc30a2ad38f097c8955fc49b84005364fda4ecc67b24fa3e545394543a2aff"
    sha256 cellar: :any,                 arm64_ventura:  "1f6f395e12547fcfcafcfcf52501dce17024aacb8fcb8a2270e42595ac5a80c2"
    sha256 cellar: :any,                 arm64_monterey: "7a786a2608afa79835cab95860405402c716916bb2f79b5e562c838269e178b4"
    sha256 cellar: :any,                 arm64_big_sur:  "12a85b410fa6b4c3e47e518813e0907b09ea01ed917ecb39354488ba1afb8ee8"
    sha256 cellar: :any,                 sonoma:         "24b7509e05939b0bbbcea8ef151073522022d59632838c29a5cbeb759ac63eb4"
    sha256 cellar: :any,                 ventura:        "0e4540078fce3d303b3a5cc1aa147f1eacb41367d39fdbeccd15e8d9c125d86f"
    sha256 cellar: :any,                 monterey:       "9c27b5547869cf439f7d5fa99b8bc7de3931f3ea73d113e14d1ad013dbb189d8"
    sha256 cellar: :any,                 big_sur:        "8932e35ce2fd13b2ba082af71db656adc9c9413280b279067773ceea8542dc3b"
    sha256 cellar: :any,                 catalina:       "e228f81df252c35872df1c6e0711857ad7a7312aae17304a7bcefa0905106b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "629245be8b81ca21008f231fbda9b316d87b06d94b42df62fbd00b8a600efd38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0288eb31c63b100814238cd97f4fb9ac7e26fde1bd284b2dfacee67df8de337f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <jthread/jthread.h>
      using namespace jthread;

      int main() {
        JMutex* jm = new JMutex();
        jm->Init();
        jm->Lock();
        jm->Unlock();
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ljthread",
                    "-o", "test"
    system "./test"
  end
end
