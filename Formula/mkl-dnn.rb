class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.17.tar.gz"
  sha256 "3473da3b486934da169895a7efd6421482d274601c0aed3505b127971f233a07"

  bottle do
    cellar :any
    sha256 "ea0a6be86a6e6f2028289e7af731a593d36a5d2f13679434c1e8af7dd24dec48" => :mojave
    sha256 "c7380ab2f4619ab06e6995ed889043cd9d7afe6d746f3edb4a00fefe5dcc01e3" => :high_sierra
    sha256 "2bf8dd79f82d7733052274611827a4afa3fde74f6633378fce36b4b54fae7f19" => :sierra
    sha256 "d870ac03f81c43d715dc5f026ec3acc9fb949986bf2ca8c2f28902f3f62dbac7" => :el_capitan
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
