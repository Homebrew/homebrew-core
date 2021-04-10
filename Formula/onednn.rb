class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3faf3b7811dd37835169a9d5c57f17fd591f062029851186f9b11db117b9d1d9"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4acbd6fa46f51d990c8ea728f8356ddd603e031fb4511c67f8abc4ba1c1264db"
    sha256 cellar: :any, big_sur:       "d1383192405c35f370702a32a7960902e7cbbabaf55199fa70e7dbdaff97a31a"
    sha256 cellar: :any, catalina:      "4b87ac49d30686213d362584522af9b8594b0083d128e07c98a3fac0b809066a"
    sha256 cellar: :any, mojave:        "05ecd2c475b31aede4b877210ed3427db9aab79226f5317b9f35c56ee57d3894"
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
