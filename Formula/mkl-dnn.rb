class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.15.tar.gz"
  sha256 "a528463d5abaa1c351a2f2a755417b0903f667a6af658213567502a2a1102541"

  bottle do
    cellar :any
    sha256 "0dab3f3d0f9f93c83e688b0ec3f2f70ff1c39fd8fb016bca31f81938613a54c1" => :high_sierra
    sha256 "a116e14e37656921fa9a2008b91228467020b5ad4f3188303ebf8fab32e6d3c4" => :sierra
    sha256 "d92f64a36897592d1996adfede93c4c90da5ebd2edaab9d420c4dbb2e8e4ec3d" => :el_capitan
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
