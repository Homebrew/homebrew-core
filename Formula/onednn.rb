class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.0.tar.gz"
  sha256 "922b42c3ea7a7122a77c61568dc4512aa8130c264c0489283c989919d1f59a6d"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "ae91a741b01e328ed48d07fddac0cf613cf76b920cd217e74494dad84fa5d162" => :big_sur
    sha256 "2e88ab29b0fc4b35d6a7e6dfdc9f34d25e402af875f87a925b234234c29d50c7" => :catalina
    sha256 "38ad5e86dbdd44ad482cba8eea38afc1f14153955b386b1518ea82469217614f" => :mojave
    sha256 "e4c55b00e9d23c273cb3d1dc56cc0511b396c6247e22d0853cd22f2bec28e7cd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lmkldnn", "test.c", "-o", "test"
    system "./test"
  end
end
