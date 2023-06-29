class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.2.tar.gz"
  sha256 "8b1db9cc5799ae39c2a567eb836962de0346d79fbc3d8e6f7090a3d9f8729129"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7587594a2ed6e0af2f222b0215eb7296054888c5905ad5fc49d6cb8645f2a763"
    sha256 cellar: :any,                 arm64_monterey: "bdcc8636c8ee00829047ebfed6b9f99f295555590584e9f2352b2b01ac7301ff"
    sha256 cellar: :any,                 arm64_big_sur:  "6695e3ffc894d08f1a94403d741525e698029cf7238776ce112ce3ea969fee24"
    sha256 cellar: :any,                 ventura:        "a2822f32e6dfbfb2b43e559af60010e86d1bca594a2222ec0d4627a77b029aa2"
    sha256 cellar: :any,                 monterey:       "2dcdc5e2ae13b21534094b5fcdb9d179bcbb8f3c6194f025a6ea6879b04a1298"
    sha256 cellar: :any,                 big_sur:        "8d4125e5c102722a80b157166ba07f9c056cb1e85f02dcfa08b2a31b57d6c46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5e7eea97a45068f6fc8f856173c178af8b951d3d80c6ab40570409bfa6506a"
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
