class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.17.3.tar.gz"
  sha256 "f2396aed52ebbdac7f81d2019f0e54795b797409b3b55970a05279551ef04e64"

  bottle do
    cellar :any
    sha256 "d391b8f485bbc1b3b4bd2bb4be82a153664640ccfd50f46af15a4b2967dc42e2" => :mojave
    sha256 "5b776f0eef76fff4bdfc610c2e30bbb8a7e172f197cd592942dd91117b499f88" => :high_sierra
    sha256 "23026883c0b75b22f0e652416354e5229213aafd8d475ba6749081285afdcc86" => :sierra
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
