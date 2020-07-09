class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/onednn/archive/v1.5.1.tar.gz"
  sha256 "aef4d2a726f76f5b98902491a1a4ac69954039aa8e5a1d67ef6ce58ed00e23a6"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "6c0397633ae7e439d40026bff8593cdf90385b3f08e2a5286c9dbb1684e16097" => :catalina
    sha256 "179cc20a24a1181e27ecacbdc2ea43f8ebf4575ab798dca288fa32f842c3fbaf" => :mojave
    sha256 "6a22a61f6c15c14487513dc882c1f762036131a15cf4b2b743bb1590e3f207f3" => :high_sierra
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
