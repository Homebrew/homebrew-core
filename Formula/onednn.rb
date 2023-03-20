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
    sha256 cellar: :any,                 arm64_ventura:  "ff559da3c21cd5ed49b05e25a15cd5ddcd2049dd2c978c8cca71ae06538be79a"
    sha256 cellar: :any,                 arm64_monterey: "1f55278a77a1f3cd60453cfed7ac9d27d8ed55b6e77ec8660554e6e6316684c2"
    sha256 cellar: :any,                 arm64_big_sur:  "9e02c515c92d28d2be9e127bdf96a66bb51c135aaefbfb2fec900e032488ad5a"
    sha256 cellar: :any,                 ventura:        "5e2ae733f0a15f524097bd74d25437e8347de08ae7cae67f61231cffdc3957ae"
    sha256 cellar: :any,                 monterey:       "d5fb830adcd29200edebb51d6bcfd9f117a51875ecd9c791447916a92ba3ea46"
    sha256 cellar: :any,                 big_sur:        "01a1bca5a5253aba03e98802bb250c55f719bbcfd6316dc40d6a7c4a2060f3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6b9a1ce8b609ef11bea2f2de6ba09b7bab67f5d673cf9622ded335d971a0db"
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
