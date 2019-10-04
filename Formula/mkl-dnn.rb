class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.1.tar.gz"
  sha256 "c5aac67e5ed4d95fe9943f835df49bbe6d608507780787c64aa620bdbd2171ba"

  bottle do
    cellar :any
    sha256 "82af329d009930d7d384d5d58308132e9a589c3398619cd2c0d532114eb1ffb9" => :catalina
    sha256 "bcdb1b0ab735cecf4d03c4ee7f2c5eed265c4c8383607660e465add3f09d70f4" => :mojave
    sha256 "46a7d7d0c7a867a74224195994d6fa88024ee783b825ba7bd9eb1dc3e4de82ef" => :high_sierra
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
