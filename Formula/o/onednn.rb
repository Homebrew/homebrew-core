class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.11.tar.gz"
  sha256 "04df98b18300daf6c3aa7cc2d5e7ce8a8f430fed1787151daed0254d8dd4e64e"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef995b2f8e5899bf611373484f12a7281b9a27d97577d49945093c0ca3c41e36"
    sha256 cellar: :any,                 arm64_sequoia: "451e8362b96e3377f7b058c32b01abacc2dfe2cf2202ef41219b6e40cece1b14"
    sha256 cellar: :any,                 arm64_sonoma:  "76cd50390865c61d3249b714f3a538c637534a1635d419e345f20338aa97dc86"
    sha256 cellar: :any,                 sonoma:        "456ad2861db2dac07c92229373d160df1c8a2b27be50dae0df337637ace4f793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73104a6874941d5dda7c051efe74770254df01fc6010551d603fbca7ee43eab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd5e4fada1343397a35770eeb751133e4ca23ea706a8a7a2eec619e02e4d52e"
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
