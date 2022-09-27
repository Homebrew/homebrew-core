class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.7.tar.gz"
  sha256 "fc2b617ec8dbe907bb10853ea47c46f7acd8817bc4012748623d911aca43afbb"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34df1bbf2939def7744e48f9adcf7efba6c718d8bff498b14b195952e502b349"
    sha256 cellar: :any,                 arm64_big_sur:  "c85789ba9c848cf736baed3771eb13992087beb47ea3d0d8cf66bd64007c1db1"
    sha256 cellar: :any,                 monterey:       "dc15c513f66706b78659d0dd282b68d88dce7c7748e5a0e823e86a9c139e9ffc"
    sha256 cellar: :any,                 big_sur:        "3964faa79479cd9c1dde977decc3937007bda1c2e7f0a10af86cebdd36cd0e1c"
    sha256 cellar: :any,                 catalina:       "25b156186ef4d10036da06fd5010c4fbdf0cd7f1019d937ab3e93f8462a8866e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09133365edd6f3ca52904b8f0c00d3ad6b65a817f1ca3aba2ec9a61ed7e910c6"
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
