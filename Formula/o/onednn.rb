class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "0ed141ee3ecf2856aef4966154a19b408faac50234581aeed4bd6e9dad09de68"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0291655852cbaa9abb762103488e75188746537117a6c18fa18327d8e250b4b"
    sha256 cellar: :any,                 arm64_sequoia: "53391a62db94ee28bfcb2d3333897b6b4c2848e7505a95efb1cf50f3b7997dfb"
    sha256 cellar: :any,                 arm64_sonoma:  "5cb78db8d5ecdfa277b060913585bd6b72d46b11e0f9616256b27fb4ffbe9fdd"
    sha256 cellar: :any,                 sonoma:        "bb163e6f35879558a2b80ec365775af3956917a3f477a93badd468ae18a5a57f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ed13c0c83dd5746954b1222324abd69f7c722659aa8a2b7c93e3f9660e2739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c56d3c5c555990931a3f3634c87c634377955ef726884a0d9458acba52b47f"
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
