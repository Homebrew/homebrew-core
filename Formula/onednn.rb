class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.3.tar.gz"
  sha256 "ccb2dbd9da36cd873cf573b4201d61bdba7438f12b144e6c7d061eb12a641751"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "71e6f2b6a19f99bd434556d7f5a7015ef7f898651cd6ef76948496d63ff4882f"
    sha256 cellar: :any, big_sur:       "ff05c2e64a3d2f0a294d32e24e81fa81541a0a5af2ffdd15ca85a673d7038971"
    sha256 cellar: :any, catalina:      "593972eb11472c7a4d32476646b8dd8f76b062f0cadb232662e7baad91a89d1d"
    sha256 cellar: :any, mojave:        "e7dfe0317688e33ed7795ef577a4586439c7f7e874805ee54b25fae01dcd2f65"
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
