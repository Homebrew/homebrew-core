class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "58a7399c86789bf3756117072ed946d764ba59dd1480f0e42efd4f9b6b7b9a64"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74fa4be741943b0ce9cd19363504a49ce6f94a0cbfa0361a5626c652c73616a9"
    sha256 cellar: :any,                 arm64_sequoia: "7d384140598a1e535895855bb215fe80dd101b166d62866a7ca0134f357bc5e5"
    sha256 cellar: :any,                 arm64_sonoma:  "446d1097493e85b6aae94b0c2822346283be371608d645692f5d6a101bac2902"
    sha256 cellar: :any,                 sonoma:        "2df8790b095a27cc7ff4f4190555422c30e09fbaba5b532fb875c0f32ad61cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878667f1666cc2899898a685c86c6091d34bd116256effdf1470a851aaa2d065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf1fe35963d65f62ec13fcdd78539a47d01dfd156d989e6bac25ea1251d2a9e"
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
