class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "911275081f9cc3406cb3e7754a0f7a8200adcbff09439d6cde0a1e543f343c5b"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "facfc1f780fad43511232ab75f2cfebf678fedcff3524e71bc698134b5a00a45"
    sha256 cellar: :any, arm64_sequoia: "4d35520bd8d5bd5414fd7d19f1cad760c471634e8c0cd26697e4419abf03a478"
    sha256 cellar: :any, arm64_sonoma:  "15ecfc8355103f86f41d0610f8df4eebba3b956c9bc24ead8f1e249a8ca44aea"
    sha256 cellar: :any, sonoma:        "ddf739856bd9fe693bb14eafd9ea6cf4b12b89e6f366274fc5b8877c9f2e6c84"
    sha256 cellar: :any, arm64_linux:   "85e4ee3f0e131cbf69618e7644e9ade7e4764461c5d8ebc4dab1f301115d1f0a"
    sha256 cellar: :any, x86_64_linux:  "deff1e8da8ee1aaf4efbe84eda84c2f4fe89242c9ea99ffb9d535dabf83b627b"
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
