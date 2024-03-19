class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.4.tar.gz"
  sha256 "1044dc3655d18de921c98dfc61ad7f65799ba5e897063d4a56d291394e12dcf5"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c4b95254ce2dc2d9f8a117aca164b0c993149c6c36a283a3bc039a8b2756227"
    sha256 cellar: :any,                 arm64_ventura:  "d8d129933dd541613dcdb02bbe99ab9ac035db200adbe9d62944cd99f4268f46"
    sha256 cellar: :any,                 arm64_monterey: "36e678073c508e131aa4e52997e900c26e16ba5e066f17ab8dfc62e4271837e3"
    sha256 cellar: :any,                 sonoma:         "98f0ab03b2a05f8daaac44e9a01e5bdc6381b50b6d349aedf754e35908af30d9"
    sha256 cellar: :any,                 ventura:        "85bd67a42fd7e3ad8bc15bd3647bd5c8ed4d72e46a7f6a096e48195693deffc7"
    sha256 cellar: :any,                 monterey:       "790ba44978a8b989d499a4815e290a7da9192cc325aa63859d4d393067dd9517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1e03a857dbc65b38e38db6c8f3ce978bbc446b17cdf4a6b37c2f14ebdd01d7"
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
