class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v1.6.2.tar.gz"
  sha256 "83533fcf81cd4c4565bf640b895d1ea0a4563a5dac88af8e5c05813f1af13e25"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "64f91cb6f54390bd6caa7b911ae752e94b05a8ef786cf2d4305288608874d4f9" => :catalina
    sha256 "3b0a613d9887a030469bd677b1e580294f4edf117971d1fd042c644f40993a4d" => :mojave
    sha256 "68c70700e9ea2dc45754d330bc0e2a3f47225c17c1b8137ca5e62ad30822ea84" => :high_sierra
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
