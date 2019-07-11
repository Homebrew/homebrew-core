class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.20.1.tar.gz"
  sha256 "26f720ed912843ba293e8a1e0822fe5318e93c529d80c87af1cf555d68e642d0"

  bottle do
    cellar :any
    sha256 "dfee9b5e67f065c94b7888958d3f12e4b02a0b180d2b53f7042aa054437d92c2" => :mojave
    sha256 "e8d095387b406d50e0e444516833a90d8520ca9c4116a0c5b2e56a2b8e8f6aa2" => :high_sierra
    sha256 "d897f5146d7fe6eb539e5c994286f78df2d39c16492a59de377398efb11f0723" => :sierra
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
