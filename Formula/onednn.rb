class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.0.1.tar.gz"
  sha256 "f7aca425e9895b791a942ae755edc28f1b9f9fe9bf94291c59f33ebcf5859f2c"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0301fd22d1c02f50e305a2fc773a05486d279a2bc2202daf46416815ad382847"
    sha256 cellar: :any,                 arm64_monterey: "3d999a1092cd99955af5de70aac58e032c66f4bb35fd3f1aa50f27b9dd071548"
    sha256 cellar: :any,                 arm64_big_sur:  "94d71bc4d6a395983133dbe4fde1ad318c022943d660a2140b82e8a44a03e0b4"
    sha256 cellar: :any,                 ventura:        "d9aeabf39c62399114323b565f29fd362cadc9500839d2cb7c611173354ab973"
    sha256 cellar: :any,                 monterey:       "c365462496ceaa02aa77b32d20b209d4d2ef088aeb7cf54d5effe823b06b798f"
    sha256 cellar: :any,                 big_sur:        "c7dfc59ff9514ff12cf0f11bf993c07d2dd715fe03c4767338d2cd99a61383d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60fa1415dc58d3ada17f8b418a1fbe505eefae64f0ecc3fd21f467f60e899819"
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
