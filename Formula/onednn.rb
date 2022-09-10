class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.6.2.tar.gz"
  sha256 "baed0a7426189c6e5f1cb242c6d282d3638802cbd05772e1c4810a83bd7bc4df"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eee433982c5406504d970a0c3f7f9410933c7552ecc2c825fbf3e5783297a2d2"
    sha256 cellar: :any,                 arm64_big_sur:  "fa288400e26364032804db53ba24e0db95fc12393d3112c850074c10b4be0b95"
    sha256 cellar: :any,                 monterey:       "b5cc33c963e45eb102cf4b927d545617724893de167d8f8adf88c81a31657eda"
    sha256 cellar: :any,                 big_sur:        "ef34e4a817e0247f0e4fad56380dc48e4de49a4c32b8430f69d469b5529ffa03"
    sha256 cellar: :any,                 catalina:       "1043f3ade946ee154900c4c60ba660750d874a4ac6301dc0863e6834eb7bbd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0723b45aed2b46f0f413ae8b2d6ed701180b4eef336dbb6f75e0384c1fc0f267"
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
