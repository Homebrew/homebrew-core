class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.2.1.tar.gz"
  sha256 "c69544783c453ab3fbf14c7a5b9a512561267690c9fc3e7fc3470f04756e0ab3"

  bottle do
    cellar :any
    sha256 "8365520f2ee8245beacd14c63e8c8cf66d90f502a1ec2fe15771810de1e0fe36" => :catalina
    sha256 "6e46c0a7840a076ff108f2d6befc99fa4cb6fbe2b9b44b1592f68966fedaa85a" => :mojave
    sha256 "2ed24a849cfeb4b0a2c5d16376ac1bce5847eb4fd61e32bc18faca487ea32f23" => :high_sierra
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
