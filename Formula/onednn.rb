class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.tar.gz"
  sha256 "f54893e487ccd99586725afdd19f526bb84e3251222586850782e3c7eedb7c4f"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "bcb6c748b97370fea41fb730f939e5cd33bd2b9d486fe997dd5fcb948786835e" => :catalina
    sha256 "a23e16f86f51179216af505fcb90915e4052d5b88a2ccbc38d3e28a9049fe967" => :mojave
    sha256 "f0f53d3f8d772f451cec3c9da678acdc9a0f3f4202e5ebba29a10272cebeafa8" => :high_sierra
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
