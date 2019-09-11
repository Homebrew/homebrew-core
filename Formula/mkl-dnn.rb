class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.0.2.tar.gz"
  sha256 "3164eb2914e2160ac6ffd345781cf7554ce410830398cc6b2761e8668faf5ca8"

  bottle do
    cellar :any
    sha256 "73a4d4a4f1a6991867a047a59299d9fe5cb05841e740a3562518de385a9287dc" => :mojave
    sha256 "13a44348ab4547c1aff49916145df2f79d459912e7e8941ae5353d16e6e04f96" => :high_sierra
    sha256 "50615293b50ebb83019df817190e8bb3c2d94b1089350eb65683c945811140b8" => :sierra
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
