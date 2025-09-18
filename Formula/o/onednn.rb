class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "fa44702f5979ed5ab927f7ccc1d2947adb4e6d0e58c433149465c5fc71e3bd45"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40ed0c8fdafbf2690e160f5f262ed13c1333d9f8c720742b458bd45326347af0"
    sha256 cellar: :any,                 arm64_sequoia: "7c6ba75631fa3daad6b77b943c5c053b8e4b29578b5830936b49d4ea1b44b5c9"
    sha256 cellar: :any,                 arm64_sonoma:  "0a41538854b77c5ffe402154d60fa5aab33896104e4defffb2f65cf49e2220e7"
    sha256 cellar: :any,                 arm64_ventura: "29c21c25ac1f95bf5f32411be8f639cad12e3545fa6757d460d4887b225c64f9"
    sha256 cellar: :any,                 sonoma:        "9bf496a69ce7d875d3c5178f95ad42ab53a620d7dc8fddf7a5ec505c1099711b"
    sha256 cellar: :any,                 ventura:       "e3d05e232ffc15566a9e4617c244d377258c00a263bef14f6ffbbfe20434551b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442310d8e10564ec433c74a3855c79bd3b0052b156ed886cdd21e774b551891f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16ca38ad3d538e8b9c54e3ecea41b6475a9d65f6c1e3f4f9ffd876a7356ff6e"
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
