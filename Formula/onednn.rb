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
    sha256 cellar: :any,                 arm64_monterey: "3e00a269f7f3507aefe6e4c9be4cdc81ac39d4c4b5a1ee8783635388e05299b2"
    sha256 cellar: :any,                 arm64_big_sur:  "683de1805367225908cd6789d8e5e4533bcddb91a267dc3d9ebb915605c12f52"
    sha256 cellar: :any,                 monterey:       "5b2d4d4c55589bf21d144148dcafb89c4db0e83706caee87f295eb1504474852"
    sha256 cellar: :any,                 big_sur:        "705787f970bd82319704c0c4a789a43b5bab4e3a66b2978739536e3d546de031"
    sha256 cellar: :any,                 catalina:       "b7616727de9946a52afe0b62e448dbba100b72cb40cc59575b73b6ae583ce7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58c0a37a1589b950c845af05c7f766ce4204f361972c879c6803a85d82fa9112"
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
