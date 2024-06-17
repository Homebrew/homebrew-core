class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "5131ac559a13daa6e2784d20ab24e4607e55aa6da973518086326a647d389425"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a37f292349752f9d395381430b166fcbb31e46f0171516089cb23c88bc52f08"
    sha256 cellar: :any,                 arm64_ventura:  "bb63c85e22d171453aa895ef403a8603621904917f580645c40af79a22b7aac8"
    sha256 cellar: :any,                 arm64_monterey: "f2df0a659c8aabc39e00163b9de568966b3cdad46d8817eddd2a958b68b68f08"
    sha256 cellar: :any,                 sonoma:         "025e8595c8f7c17e42a09df624f94d3a44b82ca7944bb8aac0b0a7a24cae3612"
    sha256 cellar: :any,                 ventura:        "2f22aeb795ac0440ed8325e3bea9b55a3faf32a3b59f39fa921ab0c268867198"
    sha256 cellar: :any,                 monterey:       "998bf95b3ee7f37db5548a08cce13df928846741e011bbec259ba402203237a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42bcafc15e91a4b49c3723de5a4142bac5e225e97a2eca58966eb80547512af"
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
