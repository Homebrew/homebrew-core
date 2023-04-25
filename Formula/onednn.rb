class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v3.1.tar.gz"
  sha256 "28e31f2d576e1a7e3a796f5c33c1d733c256078cff1c48b9e2a692d5975e1401"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "db84a4e5bbac139c4176ebbb2059938d3896dd0eafb80e7d6a162953bb811710"
    sha256 cellar: :any,                 arm64_monterey: "f80631d15315e3dd6e7bee6667bc491bddeec2248acc09fa409a6d70839291f6"
    sha256 cellar: :any,                 arm64_big_sur:  "5b35eb30b2da7c00bc40ae1562bb82fe10637e0f07152e6ba0e0b57995acfa3f"
    sha256 cellar: :any,                 ventura:        "eceeb4df6532f3ac14f8935e2ab5d052a4aa724a972ee7d39bc5b9402345905c"
    sha256 cellar: :any,                 monterey:       "b2b467df736ca5462f0fa5cf172e3f1ccd01901ff4b1ae0a73a9e45753587ec4"
    sha256 cellar: :any,                 big_sur:        "60261fc234dc30f2f485fa274d9b3fbcf7aae26ef1c2cb5846ddc12277f385b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f4a79a1c7f79e75d7841f240e2196a6d25a267cdac415614372beb84921185"
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
