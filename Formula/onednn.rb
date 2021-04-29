class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "01e651eb20ca1943bbdf756804fd02d13e5ff3c84b89e3aa5d40abdeb5bb07ee"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f09616428ff73e7dea6affce58ea389735b2277dd03e18ab5dbfe23f3c9f982"
    sha256 cellar: :any, big_sur:       "d7b6e3a859de08e2b1e81a2ff7381c16a620efe176a1e09082418d8613ad72e7"
    sha256 cellar: :any, catalina:      "a0d2c430a79bda2037b5460b6835a6cf63448981947ed418a7610295042421cd"
    sha256 cellar: :any, mojave:        "f37184d40252b9e19dd884ef0be09f7c9e86fbef469e5b28dd5b87bd29479732"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
