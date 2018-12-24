class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.17.2.tar.gz"
  sha256 "56c3e22d4fad816059cc58fd8e78ab3bacbec76a6bbded7eaead66220d8e5134"

  bottle do
    cellar :any
    sha256 "d4c34463550ffd98a595f4b360e8e3e66af4163d2ada2acf3540f3ed23db7031" => :mojave
    sha256 "9bc0ff4d8458a9b657a4197cd29bac7d58e52fa2957f9dd117c63a4ef0bb64c5" => :high_sierra
    sha256 "a494d9b6626d515a42d27be546fd9eab6c704fb041b9e8ace4fbdd437a81c3f6" => :sierra
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
