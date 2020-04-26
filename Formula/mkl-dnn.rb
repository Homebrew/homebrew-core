class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.4.tar.gz"
  sha256 "54737bcb4dc1961d32ee75da3ecc529fa48198f8b2ca863a079e19a9c4adb70f"

  bottle do
    cellar :any
    sha256 "8ec4f729539f1e8b6ca35277013d0b5fe85039fdc743177d425f8a1e2f001905" => :catalina
    sha256 "675a0cbbcb2f62cfb2f45f4bf4f33101e0177a89b2f7527611dba342a40b8e13" => :mojave
    sha256 "cfa114bbcc5fd3c64f9ce1c9e60112ea098643a21f0ff2af8b530ec084c3241b" => :high_sierra
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
