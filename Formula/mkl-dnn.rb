class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.0.1.tar.gz"
  sha256 "91fb84601c18f8a5a87eccd7b63d61f03495f36c5c533bd7f59443e4f8bb2595"

  bottle do
    cellar :any
    sha256 "bdf4de58fc0425045a561359562a3a24c31a9e1d5233083a826ce3ebda26c164" => :mojave
    sha256 "d463744eb081288c3ed6e50144cd79cb2d2bade8e2f68bfb44e4a5c800cc22b5" => :high_sierra
    sha256 "18ac0edb912896c907955d3dc12c6850ebaea5e847e8ecdfdc14377b2bc60f8b" => :sierra
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
