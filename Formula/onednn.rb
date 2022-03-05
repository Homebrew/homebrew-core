class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.5.3.tar.gz"
  sha256 "0e5cf3b634ba93ef839e72da2cdc1a3affb1eb6f05a7d03349c7fe47ceb35915"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "29bf4d8de6c2f251d47d2555c5f40c22477ec41e745a92aeed200027911d00c9"
    sha256 cellar: :any,                 arm64_big_sur:  "3d442363b6d7a6dfdba5b454b72f5fcbceb3d2d6fbabfd21dadb0b11313bd346"
    sha256 cellar: :any,                 monterey:       "95d3d8545206ae998666f387a7ba77cca4e9ef394285c6b2f926ad47c4c8bf4f"
    sha256 cellar: :any,                 big_sur:        "73af69316c055c5ef8ee9cf0e50afccf9b105b407c6416bfa1a3c995e9a578fd"
    sha256 cellar: :any,                 catalina:       "6f381f0863435671822ca956dcfc272965653ee426e0babd73b1c2165ed3b128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de6964e2207f35e9c43b751d37935872cf853a24548d2a61fa116c5ba7039a2a"
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
