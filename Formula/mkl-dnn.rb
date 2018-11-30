class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.17.1.tar.gz"
  sha256 "75777735458c9e03434d9b1b111b92bca4230427b8de890dd694039dc34480ed"

  bottle do
    cellar :any
    sha256 "8c4a383393cf3ffaf2d80cbd3a0d519f8d5dc1f60ed3d7e41058a96d5ea19c6f" => :mojave
    sha256 "52797f6e0cc0fcbecceb7e696073f7e56b3e8ac4e61606f9992b14ba8920889b" => :high_sierra
    sha256 "ca9e26e3b1aaafd8c6c8aabb18cfc1f0d253b1f1750ab9c7ccec34575f3343fd" => :sierra
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
