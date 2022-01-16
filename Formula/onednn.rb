class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.5.2.tar.gz"
  sha256 "11d50235afa03571dc70bb6d96a98bfb5d9b53e8c00cc2bfbde78588bd01f6a3"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75c7ec754a71196b2e5129b2c95ffe6f1b02d44a473c5dd1fb0f8eedebeaaa1b"
    sha256 cellar: :any,                 arm64_big_sur:  "d9b10a54af84644db823a6aa7cc03e6db4907c0143c97655cf30f138d3ddcec8"
    sha256 cellar: :any,                 monterey:       "b24dfbd874ccba9555746ded76b4d0c63e91c9d0ee2119b5bef59347db44c102"
    sha256 cellar: :any,                 big_sur:        "ad063b3ea915b23d8b97acad5bdc27fc9dcd60cce02561ddcbbcaf89bfe6ce7e"
    sha256 cellar: :any,                 catalina:       "3faa37be90280963cbe5a31d739e656490e28c1cf45ef06817b109ca1113dfc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f7f3f73a554b7e9b7e7056a04a92a4c122280d5f2fa92bc8446a711bdb456d"
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
