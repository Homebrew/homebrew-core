class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.7.2.tar.gz"
  sha256 "49018ee24b1b13c166510354c03c2f1489262b10ee09b12cdeaec5745f99ac50"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5bda2d01c6e388999d4e6108ddb02f8b783b667bda55aee303a8d107564755d0"
    sha256 cellar: :any,                 arm64_monterey: "a8914c902dedb8f42c07c3738f7443ecf48727c7bef8a6df1c1a746521fb475f"
    sha256 cellar: :any,                 arm64_big_sur:  "8012a5e071e18750464dc9f9c4e00abffca7afbdf2958032e48bd89c35bd26fc"
    sha256 cellar: :any,                 monterey:       "66a06bfd997565fa052ffae1884963114f187658f9f397e3fc01e91d5ea178f4"
    sha256 cellar: :any,                 big_sur:        "36632b0cff66d6bfc4fa93406afc911dcbaef091ea5184f11288c5b0e7bbbaed"
    sha256 cellar: :any,                 catalina:       "10af1700bce6070e6d4525829250445667cb8320a4729bee64dde586b8be0223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e93bd5ed77a2bb2388cb95fb28294423ad4b5896b85927c9d3d7237810aa85"
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
