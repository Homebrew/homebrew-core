class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v0.20.tar.gz"
  sha256 "52e111fefbf5a38e36f7bae7646860f7cbc985eba0725768f3fee8cdb31a9977"

  bottle do
    cellar :any
    sha256 "e451a112fb3b6524e00fbdd4099cc4642934439cbb7473d1972baf09a85be0b9" => :mojave
    sha256 "138f18af998d03012f519e19682759d1fd3f85dc68e7683561729b1c01b6d103" => :high_sierra
    sha256 "c5393b51317f4751ac30a0c69db85fee8abb26740cb7e26610cceaea51348ecd" => :sierra
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
