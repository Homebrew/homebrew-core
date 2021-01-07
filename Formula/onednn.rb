class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.0.tar.gz"
  sha256 "922b42c3ea7a7122a77c61568dc4512aa8130c264c0489283c989919d1f59a6d"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "d17e096d72bd885c7cac190adfc750e482a7e65d44886f73481755792198d5ea" => :big_sur
    sha256 "51e627c893ce04790d65e625dc2acd3014cd69020bfdb89f3401848283988a49" => :arm64_big_sur
    sha256 "b4fa356473727ddf9506f7705739237c397b7c967df761a5b80cebfed256d648" => :catalina
    sha256 "defca13c472154c8faa951b61476964965824c07baa3ab26419e4d5822a060b0" => :mojave
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
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
