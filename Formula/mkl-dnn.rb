class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.13.tar.gz"
  sha256 "d2cfd93a70cfe86ebe054477c530c9b5c1218b70f75856eb6d1956c68ee89e8f"

  bottle do
    cellar :any
    sha256 "d15b58e48a219234b3ab9150eb4037054c1ceef41131b1dec963ded3a33f1160" => :high_sierra
    sha256 "100918b030da7bc12b3097540334adefaba3db21e91e970a9dcd22ece323c4f1" => :sierra
    sha256 "a7c0feef8748486474eea2efe45b50c7fa3ab0320d1447bd8d3e81cd83feffd2" => :el_capitan
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
