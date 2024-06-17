class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "0583221e8fa9404eb9805a99ec96446f1fea9731250b01707e7225cece7878a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b51fd254fb664f054a75301fa0297835d4f80eadce6768ba728a64c7a416b506"
    sha256 cellar: :any,                 arm64_ventura:  "6311d836e32f2cc72490c1484418f76089bf27b37fe5c1e5ddd77ae9fb3953bc"
    sha256 cellar: :any,                 arm64_monterey: "fb7961d1461685a6dd70c8d14a4598114ec3bb4d4183e8d30a93f5c8b7d70667"
    sha256 cellar: :any,                 arm64_big_sur:  "b10ed4a7fc586c070c09e41301d61bad6a446ec1cc5b1a6f5b033411e2618b58"
    sha256 cellar: :any,                 sonoma:         "0f453d09a5c7cea661ed4c8402d19004ce1080c7c51bea7636ef60e18de5422c"
    sha256 cellar: :any,                 ventura:        "cd528ed5f81d091514814fa741f0f0446694d1c46c0ed4cf151f3a3c75703c22"
    sha256 cellar: :any,                 monterey:       "f502db9e4dc4e0e0bd218d89facf211672b64a126a8d107be672e193835dc5af"
    sha256 cellar: :any,                 big_sur:        "0edf7381b5f92ae438f6fec144e6a50786d82ee8e9adf45f22f6e558ec209c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17184b4ef23c26a8786392aabc829373e154f51915961761fc57a13140d76206"
  end

  disable! date: "2024-02-15", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
