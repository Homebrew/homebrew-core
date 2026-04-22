class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.11.3.tar.gz"
  sha256 "7293a85e146c2710dcf4f7257fdebb91020004cf1627c8de684b814c2498c81a"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "900a1d5fd061d901265ad222c3c22053b623d602ce7755dce3facafff672f66c"
    sha256 cellar: :any,                 arm64_sequoia: "ee256fa0ae08fe44a390e2d18e9754557ea637955f49384b0bbcc9ed8164faab"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d2b8004bdf69182fcf987913c409481311e6a1918feb1f50c01cb3bba46540"
    sha256 cellar: :any,                 sonoma:        "da00a288e8ed6fe78bf366cdee8915e39fad4930566ec3766c91b636c5786e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48653dc497ffe12a5a540ebb43ec48f9f464b5fe2939a439ff001024c9223ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccff3a90526d8cf8946e06a2503d99b990844bd56f0d37e01d7817c395ac14b4"
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
