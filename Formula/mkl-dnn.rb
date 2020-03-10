class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.2.1.tar.gz"
  sha256 "c69544783c453ab3fbf14c7a5b9a512561267690c9fc3e7fc3470f04756e0ab3"

  bottle do
    cellar :any
    sha256 "73ec3df2edf97f64da0b23b28ba389c80fd22847a383ddff4f8bf669262f3ee9" => :catalina
    sha256 "47fb94ec54d1c494c07aac64906b26a83b68a324e715f6debb5a6e8f8bf5c79f" => :mojave
    sha256 "2eb0f9b36a3511e72aadfa1f6516c4c8b80f85aa7696a7b22ff0c1661fb0036c" => :high_sierra
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
