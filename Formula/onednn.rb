class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.1.1.tar.gz"
  sha256 "d1cd58f57b2308d362a9bc474acbc21524cb879cf5d8779b460c718f0fac82d6"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3841f7b8673050ffbb7c920905db3553456ac9e7457dd65c526066a02ed66a37"
    sha256 cellar: :any,                 arm64_monterey: "04517e9a426c23eb19695c102fa16e9dee9bc555f866e95c604bd4a6a34a56cf"
    sha256 cellar: :any,                 arm64_big_sur:  "e503c20c2caf51650dee6a425f67ae0c29737deb952962618b0a9c1763d02a9e"
    sha256 cellar: :any,                 ventura:        "c5f91289998adb8881899898f924305fdbbf309004564f01dce332fee7f27d77"
    sha256 cellar: :any,                 monterey:       "d6f205f975c386fccb289f5d19c1847c4f507930b30656aea2769a7531bb7c30"
    sha256 cellar: :any,                 big_sur:        "484d10f4ae75eae1395fcc266e2b587c35070f11cd849e3645fdc374ba5942b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7beed61b9f3b6536b96bf5121e1c18a355124c5c92047db6ea2a9755fb7a8971"
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
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
