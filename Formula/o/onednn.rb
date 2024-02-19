class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "e291fa4702f4bcfa6c8c23cb5b6599f0fefa8f23bc08edb9e15ddc5254ab7843"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84a1024db29f9fd706a1280784592c5d58e1cf0bd6c361269620472cb0dc3e7d"
    sha256 cellar: :any,                 arm64_ventura:  "993156cc72c58817a59310c78139547faa96a879555bfa89595238ecbebcdfed"
    sha256 cellar: :any,                 arm64_monterey: "d8745977b3a054108442f88c87f9c2f27d6d7a267357b7f06db69d623d536de0"
    sha256 cellar: :any,                 sonoma:         "9bba74daaf0b70c892b02429b3f0e562e6109634c3b3edf51d722b146c986201"
    sha256 cellar: :any,                 ventura:        "be8b9af9d1aae916f403f71078be5543956f1f76b0f412b6682648f97772611a"
    sha256 cellar: :any,                 monterey:       "09b399c855e35af8510916ae570094d075bbce7af36959b81071e84e9625726f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47caa7925a6c1d72c31ecaeb0c54596cd5846b265a9e31e3ec435777a1f9513b"
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
