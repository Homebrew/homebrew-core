class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "d89998bfae2f33c209e216e3d3a8d280ed6eb65a57971dfb4dcfa56beac9571b"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3814e423a07f42572e8afda7d227357a5307f6b3784f7b97f17f8345fc663cc"
    sha256 cellar: :any,                 arm64_sequoia: "48bfe23d66cc4f6476b5823d69d638a68596abfe355a217c24301d89cef563ca"
    sha256 cellar: :any,                 arm64_sonoma:  "8bc9b49360d48a2b1ad1d3926db6e162fd35341d0f55cd34a9b0bb4ac398c0c1"
    sha256 cellar: :any,                 sonoma:        "31dd8a90fc43974f23be032ccb8474b6d789108b6e4b88aa407023e551d323a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4766deb3d6bed8d4ee3cf0aa520bd5885ab7b4ab595f86ce8d45f97248a17606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c9f5930114e711d48b91d2adb06838442485a5d0e70dfe4ac48a4df23a1a8b1"
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
