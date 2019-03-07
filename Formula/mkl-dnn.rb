class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.18.tar.gz"
  sha256 "38a1c02104ee9f630c1ad68164119cd58ad0aaf59e04ccbe7bd5781add7bfbea"

  bottle do
    cellar :any
    sha256 "39cba676ffaf31a89c1f6b35eab38d3c092092c5ba7ceb60550de69e5b5ae295" => :mojave
    sha256 "22ef5743ffd9d8ccefceef7e9d993f44363fd9a923588c1a72456cf6268c9086" => :high_sierra
    sha256 "88bd6becf58656b49f999b2eb3d24da584bd55f46b0c25a8fb2b7d8b6babaf7c" => :sierra
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
