class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.0.tar.gz"
  sha256 "27fd9da9720c452852f1226581e7914efcf74e1ff898468fdcbe1813528831ba"

  bottle do
    cellar :any
    sha256 "a0d1131a0137a558871e2c9a2431ce3f44fc8e8ab0ab9fdb248a9ebc35732ef9" => :mojave
    sha256 "3d1ce44b0785bd213250fc03df17f69d9320ce2df060567ace0b757aae20d016" => :high_sierra
    sha256 "b1f6584f758e2df55b0b1b6ce28b70ebff69f3803a972b489d688f0cb81e3725" => :sierra
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
