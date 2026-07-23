class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.13.tar.gz"
  sha256 "f90a34cc3f1a5af511570d72f4437205efdf97e1d28c576418daa7ef1a34daaa"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3c79d1dc6b878eed0e201d8f6c643bafc9434291bea6831478f014f6fccf824"
    sha256 cellar: :any, arm64_sequoia: "9e4232c18a514bd861171c4ee3f91252db3d92a78afd3dcf2f55fa50ba15d33d"
    sha256 cellar: :any, arm64_sonoma:  "1c9a94e72f7586dd771c3de00d191b9677ed4af989f00c6375b6394a8287ac1f"
    sha256 cellar: :any, sonoma:        "2403e502f0351aa69fa8fd2685fbab56580cda44f03007fcb4090b10b9c3b6f6"
    sha256 cellar: :any, arm64_linux:   "d925663eac698814a77bc9580e8cf043a65588d3f2b426e4c3e355bad676ba75"
    sha256 cellar: :any, x86_64_linux:  "2923619372a5381b502741989ffc9f8e2f02a812a2ccc4a27543b841c8e9b85a"
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
