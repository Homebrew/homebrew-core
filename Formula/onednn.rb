class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.6.tar.gz"
  sha256 "9695640f55acd833ddcef4776af15e03446c4655f9296e5074b1b178dd7a4fb2"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db00ab12ff94df6310d42d84c5bca895cc2c693b7c34b40d84dcf26386eb7f46"
    sha256 cellar: :any,                 arm64_big_sur:  "aa6038dd47c886faa7f3d4440112c9eb6ccc0d9aac020ddb7881196bf2eba23f"
    sha256 cellar: :any,                 monterey:       "469479abe1b8f7160217dcebe981f890edd1fc742933db9d718d0a180cb64eb7"
    sha256 cellar: :any,                 big_sur:        "30847804f81e8a9aef031b5ba343d8610e4de5bb0087d411a571740f7260afd2"
    sha256 cellar: :any,                 catalina:       "a22af2b242cf823267351d0df62717bdec5f852288af58f7e22c339d9460d447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dc17714eeee14130bfeb769c8c0c257cd117e42b383fcd185d26e6efe4b170"
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
