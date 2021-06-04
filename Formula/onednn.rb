class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "07e5cc2a30e7bb5a381eba04f8579f427372132ed3d44363f5fd89850a7b50fd"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "86faf70b71b1e8b1a2e158c5941636c975952816753de7d14614331d4b4beed0"
    sha256 cellar: :any, big_sur:       "8bd53ed7d66fb66d854191c8199d4beddf1d3636ed1fb7087a2a786b59d7d0d0"
    sha256 cellar: :any, catalina:      "b608e17b31fb97717b7aeb6f8031693342d13d8a1852eb9419a9fe5520a6f8b5"
    sha256 cellar: :any, mojave:        "4c30c66468837d03201bdbbfa297787ca3d05946937a733522f54aed43d1b5ff"
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
