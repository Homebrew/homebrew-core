class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.13.2.tar.gz"
  sha256 "6f2240c94557117fdc1954145148c9dff440d1e5c1aeafc1096f3c7bc03a41b8"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b3cf68f05f40fe3b14d263d0129350e8a5563f9d327b5fe9c291dd2c28f212cc"
    sha256 cellar: :any, arm64_tahoe:       "138a0364f373cfe172bb6b900214048b29f167fe4a4980b5a415196f94ee0e82"
    sha256 cellar: :any, arm64_sequoia:     "36e3cc0a9c7a85f2d1d80b95d6346d7665206617ee19539f795e76e053683301"
    sha256 cellar: :any, arm64_sonoma:      "f1efc197dd44cc1161daf485c01cc559d105cbe90baa0d2a6c43cd02a3982414"
    sha256 cellar: :any, sonoma:            "596e6cf8591dd09b041d3085aff2bb3acfe474288ad5e4d3e54419c574a8c6df"
    sha256 cellar: :any, arm64_linux:       "9674adf92a14edcfa6c1aa194f05898402f094cf0ddc19f6cc079c04c2e9932b"
    sha256 cellar: :any, x86_64_linux:      "9a6f495782ac896e1ebe659987fc43a21d97446923624d9018dd65214de9449d"
  end

  depends_on "cmake" => :build

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
