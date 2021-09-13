class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.3.2.tar.gz"
  sha256 "8cbade2dd955bc8f281d31a2e89e7ad7b11d73cd8281c30a64b2ff8e3a63f07e"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b689877ed49e48e5ad7d10c3f7b6175f3e934b8762eaefa833a3a188cfc0905d"
    sha256 cellar: :any,                 big_sur:       "54de4099e0e24c93e94437c1a3cea1844d5bc0f1a6dc50f75e8f2fcd020e9eac"
    sha256 cellar: :any,                 catalina:      "3f0e47b458db78e9294e5970f6d7eb023cc9abef4fc03efecbaab5c62f41f80d"
    sha256 cellar: :any,                 mojave:        "8beb08cae2c9e6161b8036e55e8cb4ba286aac5733d9dfe6ff9a2248c955ee9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6e31c3b47539ccc243a29881134ae1756df7b906c32cb897c5a9a9aae26e7a"
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
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
