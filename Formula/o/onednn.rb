class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "21068e8cd2bf4077916bf31452eab5ac9998e620e1b22630a88f79c334857a5c"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a897aeabdd97355fc486dd3a192964f599c08665af7cf578ab54f67260ca95f5"
    sha256 cellar: :any,                 arm64_sonoma:  "b6e695edfcaddbedef7edc16204e117e94c325cebee530b25bce33b7e8e47585"
    sha256 cellar: :any,                 arm64_ventura: "ce70a409203c8000b2fcb005435e7440666ab534b51e058293bed8461da199fb"
    sha256 cellar: :any,                 sonoma:        "5427a73324de263f78e6d0415bc32f8c23bd70b468187fe916cccb1d8ff5a077"
    sha256 cellar: :any,                 ventura:       "1a5a3e5474768ed1785faa686b4a3e6c605d20d3751ad7f88fd26fdbbb33f78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332315b05ee766f7ac2554bb88a7e93802a480902c299d1092277fe679d47f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb44e7a4780b568d36f1ef61b06a4886cbb05aa3bfca2554cba76ebcd34f9acd"
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
