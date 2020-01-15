class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.1.2.tar.gz"
  sha256 "284b20e0cab67025bb7d21317f805d6217ad77fb3a47ad84b3bacf37bde62da9"

  bottle do
    cellar :any
    sha256 "8a6caa9c802ebef876879d02abf2e696fcffcb00eb1b9a8f8694828187d2ecac" => :catalina
    sha256 "83997962467425ea6bc44a66c21089b47bcd646173e448250673ed2388abc0ca" => :mojave
    sha256 "34b518c147aafc361b43d78ff9b4271f229405437148c9ccf6a5e88a48daf4c1" => :high_sierra
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
