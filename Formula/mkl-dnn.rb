class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.15.tar.gz"
  sha256 "a528463d5abaa1c351a2f2a755417b0903f667a6af658213567502a2a1102541"

  bottle do
    cellar :any
    sha256 "9b3cf6aaa46daf788abe0e4072274ba8e99d3a52f2c8d52a750a98ee38ee9eb6" => :high_sierra
    sha256 "fe3829143f42992c0842d505d65ed635416053d3c6bfe1136d4fde58bd2e56b6" => :sierra
    sha256 "9067ccdd5cb62b9ec4836792603445df912a15384ccfb07b58a737f229251913" => :el_capitan
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
