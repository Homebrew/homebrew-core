class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.20.tar.gz"
  sha256 "52e111fefbf5a38e36f7bae7646860f7cbc985eba0725768f3fee8cdb31a9977"

  bottle do
    cellar :any
    sha256 "60f06a95615496166e2948e72d935aa83e77808023b366952b540e3726ee382c" => :mojave
    sha256 "7cc748411471f6e987bc2fe58b8928c6c81ea624f10b8fd811f3714f57210f9c" => :high_sierra
    sha256 "087f5df39f8fb63ea637ca4a5e9451b7f90a5821e346a0e96c5e76d725ae0a52" => :sierra
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
