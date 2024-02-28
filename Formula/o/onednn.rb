class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "b862805a80052db826a95a31c77bdad92807c061abec9152c7e6be5f3558c1d2"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad4df4aedd1b6c29fe8a94996cd1129f1290ec0c18e83a69230672198abec19d"
    sha256 cellar: :any,                 arm64_ventura:  "4d1c2471cfa951545efaea4f4ec75176adeab8b0444c47191f0d560bbaef8dca"
    sha256 cellar: :any,                 arm64_monterey: "4c859da6c042c8e421767d12a213457f888a3f4893c95eee9f8a6bfe65252f0f"
    sha256 cellar: :any,                 sonoma:         "d13ae1d09d0df3ef5f6881115a7685d4c5e08bf6f7a3c2819772de8d432fde57"
    sha256 cellar: :any,                 ventura:        "037d9f463d13f47d70f024aa8a5f2dc7f8a4cdd5ed5e3cdc611a3570a4a945f0"
    sha256 cellar: :any,                 monterey:       "1c27de1ef94455e170c0edf8b81fbfe44d64fadddca1585cf242b125f7741702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1342dd271937598265036ca8f4f2df15478f96b7504f470fd89031fbb56f2793"
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
