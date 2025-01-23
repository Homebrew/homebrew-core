class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "e79db0484dcefe2c7ff6604c295d1de2830c828941898878c80dfb062eb344d1"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55a871e4cc85c375e85afc4c0033e2454009ed781b9ff1891f10a79dbe4c0a8d"
    sha256 cellar: :any,                 arm64_sonoma:  "a4d8ad31b54d27832580f64674e73cc9507fd58e43de3efcffc02d7a344cf565"
    sha256 cellar: :any,                 arm64_ventura: "3836cbb64b46944560d612d896db06fab94bfcf5b85934003678278093946887"
    sha256 cellar: :any,                 sonoma:        "b5618c3b968f3ffbffc9606958de1417bd07c7fbb804515c8b7b0dfc21049a2a"
    sha256 cellar: :any,                 ventura:       "9f42b41e4f17f44deca0516b523ceb311551b20794e2992ac5c600dc0dc728fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8e0bdffcf7d4f862a71f286061142d90bea9889a12efb887054731b54a71085"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
