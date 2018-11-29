class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.17.1.tar.gz"
  sha256 "75777735458c9e03434d9b1b111b92bca4230427b8de890dd694039dc34480ed"

  bottle do
    cellar :any
    sha256 "a362c605615e960cf1f5f412ec1f27277f2b4b28dd8d99d04d3fd567d50f395b" => :mojave
    sha256 "5020ed2999c612d1f5ea1c5a6dca4d992ede51d54af3b4be8091501e963726f7" => :high_sierra
    sha256 "d870b6a2b8498491bbe80c789c9d15326ef6fb772f5213cd8a4cdc7df5a91e0c" => :sierra
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
