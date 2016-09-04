class Mbelib < Formula
  desc "P25 Phase 1 and ProVoice vocoder"
  homepage "https://github.com/szechyjs/mbelib"
  url "https://github.com/szechyjs/mbelib/archive/v1.3.0.tar.gz"
  sha256 "5a2d5ca37cef3b6deddd5ce8c73918f27936c50eb0e63b27e4b4fc493310518d"
  head "https://github.com/szechyjs/mbelib.git"

  bottle do
    cellar :any
    revision 1
    sha256 "67368c6f48d8af6f70eb8f9927a1a0d7c9ee7cb245700ff708e74c751536fc0a" => :el_capitan
    sha256 "d2aa6f1c7c37ad0de9d49c2a18947314f5d790888490024456f2cdc2877d05ba" => :yosemite
    sha256 "95f0f605cef097156dda1f68b451eced4c36b74a7dd520a4aa1be26d30423550" => :mavericks
    sha256 "3931a6a0b89f5b170df43b91a7e5a1e348c9b13d24d7001bda51d034cd72bef6" => :mountain_lion
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
    (testpath/"mb.cpp").write <<-EOS.undent
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
