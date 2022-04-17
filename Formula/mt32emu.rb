class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_6_3.tar.gz"
  sha256 "a24ee0a8ae9aa4138ffb185f123768b23fbb8b5b3bebb07882f3ba2836ed4905"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4492e6c200f0bd8698cc5499317187188ac977f038e2ad4f8233805530ab5f5"
    sha256 cellar: :any,                 arm64_big_sur:  "4048ea13e2d8f2f5607792f525b7c94d2c101b19ce10777291fd8ee20cbfc3f5"
    sha256 cellar: :any,                 monterey:       "37b39882c3d3d967deb9be1b70d567e3113befcb2b8fddb9bc7772cca248d537"
    sha256 cellar: :any,                 big_sur:        "b94aca312a72445e65de7b8d53452481be8f98302e1362a1d970734609228f42"
    sha256 cellar: :any,                 catalina:       "d27dc76745777cf9b263f28afaa08da3d0fb9fa2ff10704d6aed1fb802c9a8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2247dfc38da5d9a6922da38833d42dc5e1bdd1f99ba21d33b0d5ee7564ed58b1"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  def install
    system "cmake", "-S", "mt32emu", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mt32emu-test.c").write <<~EOS
      #include "mt32emu.h"
      #include <stdio.h>
      int main() {
        printf("%s", mt32emu_get_library_version_string());
      }
    EOS

    system ENV.cc, "mt32emu-test.c", "-I#{include}", "-L#{lib}", "-lmt32emu", "-o", "mt32emu-test"
    assert_match version.to_s, shell_output("./mt32emu-test")
  end
end
