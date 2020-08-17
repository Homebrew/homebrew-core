class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.1.tar.gz"
  sha256 "6686d01d9493905c9c8bcfabcf5b2cc9ced7de7a41c52bba99e569fd5b63464d"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "7f297eb60b4d60a136715f5a8febccd02d890d895e4f352b6c0b88612dc1c0c2" => :catalina
    sha256 "3a03c506e8677e984616359270e4c44e2dedffaea3e991044beae959b986bd39" => :mojave
    sha256 "94c7edb6e4a5fb1168977d5a463c7ca8f61b4164765545cfe33a1132fbe68197" => :high_sierra
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
