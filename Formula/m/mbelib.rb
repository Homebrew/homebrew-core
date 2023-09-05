class Mbelib < Formula
  desc "P25 Phase 1 and ProVoice vocoder"
  homepage "https://github.com/szechyjs/mbelib"
  url "https://github.com/szechyjs/mbelib/archive/v1.3.0.tar.gz"
  sha256 "5a2d5ca37cef3b6deddd5ce8c73918f27936c50eb0e63b27e4b4fc493310518d"
  license "ISC"
  head "https://github.com/szechyjs/mbelib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5efa031e17f6e6fbfa06cb1bab625af8721ec46b287044fa5cbb0e0567417a80"
    sha256 cellar: :any,                 arm64_monterey: "4a189fcd966e9a57fb11df30a7e136d98bd7b2e989d01af3731117475e2afc94"
    sha256 cellar: :any,                 arm64_big_sur:  "053dd044423318deba18dbccbbd1d85efec94b507dd5646beb7b6c3d32064010"
    sha256 cellar: :any,                 ventura:        "81eca52ffaa4828961e274c2c00ff39574ed1f9fddbc2d55fbea56068d2882e5"
    sha256 cellar: :any,                 monterey:       "925321b8a121e7cae27ec3736d1035d27d9945255ea9113f430c5dd15e7d4b7e"
    sha256 cellar: :any,                 big_sur:        "508ed0ed1f9603c7c3e50accea0e201d391f673b63a4acb71574827fddcbb1ef"
    sha256 cellar: :any,                 catalina:       "fb29c40fb9af7c0303d9f7929e61941e8c10c8aad57662f366a671d3a73be116"
    sha256 cellar: :any,                 mojave:         "85f9f705e2e25ea205b637ad34bdc1e3d24734e646e6e6e53d39ab085a691303"
    sha256 cellar: :any,                 high_sierra:    "710bc1a0458b96c12c0a3b675a3410b1d86257ceb36370fd94952891e1a9b744"
    sha256 cellar: :any,                 sierra:         "45f0f9fafbe773fab43f621c62ce0c117c1d9a01fe32528b8b18fa6e94671a22"
    sha256 cellar: :any,                 el_capitan:     "8cd7158aaccceca6fe78a8031f1d58189b269b0dee86a10c349d3d514c4e33e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa416bb9571e03c0bb7b877a44f08e874f069367367ca6c3bd6cefb87ecd70d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"mb.cpp").write <<~EOS
      extern "C" {
      #include "mbelib.h"
      }
      int main() {
        float float_buf[160] = {1.23f, -1.12f, 4680.412f, 4800.12f, -4700.74f};
        mbe_synthesizeSilencef(float_buf);
        return (float_buf[0] != 0);
      }
    EOS
    system ENV.cxx, "mb.cpp", "-o", "test", "-L#{lib}", "-lmbe"
    system "./test"
  end
end
