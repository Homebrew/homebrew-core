class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.18.1.tar.gz"
  sha256 "fc7506701dfece9b03c0dc83d0cda9a44a5de17cdb54bc7e09168003f02dbb70"

  bottle do
    cellar :any
    sha256 "ac17d1c4e9d3519959d55c51dc5cd5644412457d097f816c93932e818d0e90c6" => :mojave
    sha256 "a23203dbbf531d6f0d8ffc07da7f72513ea048ccda4c19cd3e0e3ab102a3f56c" => :high_sierra
    sha256 "04709a34737fe09d980a57c9f69d252060a1cc27ed8d2af83dad3d82f96f737a" => :sierra
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
