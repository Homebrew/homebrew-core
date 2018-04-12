class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.13.tar.gz"
  sha256 "d2cfd93a70cfe86ebe054477c530c9b5c1218b70f75856eb6d1956c68ee89e8f"
  head "https://github.com/intel/mkl-dnn.git"

  option "without-doxygen", "Do not build HTML documentation"

  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :recommended]
  depends_on :arch => :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc" if build.with? "doxygen"
      system "make", "install"
    end
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
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lmkldnn", testpath/"test.c", "-o", "test"
    system testpath/"test"
  end
end
