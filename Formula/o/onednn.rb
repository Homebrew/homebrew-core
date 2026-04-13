class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "890ce734737b6f6b356bbbad211b2beaa74496a941a99e3f45bff9cad8ce0077"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97eedea76bd095bd06d642fd755c6296cb04412ed48592359f6d221b01d9141f"
    sha256 cellar: :any,                 arm64_sequoia: "89cb0b4f4b8951bba832ff252e63d2839a4a164c7307e982b9e00679b4e1aed7"
    sha256 cellar: :any,                 arm64_sonoma:  "dd304924a4b20c26650345e0cffb2354635f05b4695485f518d7eabfb05877ba"
    sha256 cellar: :any,                 sonoma:        "b85b44ce490a3f599e41b42239a11a24e2aff88a3519d37ac402628de6b620f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f689a413a5f2851ad8f43231a5202ee4d96880345837e8179ecec677801ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a0c7db7f364aa7ddd5e307a824d68df0c7d95bae6dcfb1377ecac2398d6a39f"
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
