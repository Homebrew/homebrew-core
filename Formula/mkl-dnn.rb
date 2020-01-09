class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.1.2.tar.gz"
  sha256 "284b20e0cab67025bb7d21317f805d6217ad77fb3a47ad84b3bacf37bde62da9"

  bottle do
    cellar :any
    sha256 "86fa546726d483d7fb1ab4cd48ae3892e387c3ad6314442002ecca6efe738b99" => :catalina
    sha256 "1ff1b2eea6846102c2b63b80ad28e1bf9edd0acf27ba31da883137c575e80a78" => :mojave
    sha256 "8973b73f14f9c36a1fe9dc05a0d4820351506d3102a17a2496d1dacb031de83e" => :high_sierra
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
