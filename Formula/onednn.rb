class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.4.2.tar.gz"
  sha256 "e829d822a6d65cbf89fd3398982b52dac8a6e24834081e605ec30d15cdc42873"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "10f08b24fbf8446eabec027a28a2161284616fe3b175ec54044138b4fdebea4c"
    sha256 cellar: :any,                 big_sur:       "7321072e3750241e728c82356af833c79c37733f310d868b9618952f57bd35c1"
    sha256 cellar: :any,                 catalina:      "93a396beb7dffd8f0bf4571e703e5b1a2752801e905062cb5384ca1a5a360ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e6f92d861d557bc9f803739f4d96db4d8d2f9a4bad41b3d2efe1f895bf3bec"
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
