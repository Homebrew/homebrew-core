class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.6.tar.gz"
  sha256 "20c4a92cc0ae0dc19d3d2beca0e357b1d13a5a3af9890a2cc3e41a880e4a0302"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb357a7d8d4e660ec0bdb87021c74709d6f12b8b751eae5577ed4eaf05e5ddd2"
    sha256 cellar: :any,                 arm64_sonoma:  "d44563b82a6a8d60fd8b10b6b84838480f853a945b3c1680c610bea1647a25a4"
    sha256 cellar: :any,                 arm64_ventura: "fc73a3f2ea4c75e02bed8fb850b6704b0a427e6fd78000baff7f11d2ba916e74"
    sha256 cellar: :any,                 sonoma:        "2569e1c502d32692301cd0058a2ce0cc6a4052c986857a72e08ec97b7195a03c"
    sha256 cellar: :any,                 ventura:       "2c44e140855db6e46d8d5ea5df9bedc5a814ebc3189abc7059238666e2f5b3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9aea6669abe6b3c8f78c00ad7d09f70cad33eaad9837d0c933a5d9d8d1133bc"
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
