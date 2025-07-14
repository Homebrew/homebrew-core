class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.22.tar.gz"
  sha256 "d33ca3990513223880ec238eb2e5aa1cc93aff51c470ef0db9df3e0c332493d5"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "831cb59dad3bca5bed6c74817fd5597fdd4fd54ae2090e3ebab6ef5ef54a7fc4"
    sha256 cellar: :any,                 arm64_sonoma:  "16a11167f071f03bd1e765f0c8589a5d6bc344a0fe2d2deb31c0de8ed76fa751"
    sha256 cellar: :any,                 arm64_ventura: "d78d4fbae7b6cc939fa66c4dd2076ad656da648a166f678b2eacd2e61e24588c"
    sha256 cellar: :any,                 sonoma:        "53fbcaa96206292e4bf9c2cd1a1ff58923aff7a7e2158ed7e9b61c1fd8cbc672"
    sha256 cellar: :any,                 ventura:       "7dbb5b441482ca8698090704c45aa776b2680957ae39325c93fc5ae7b81a2b80"
    sha256                               arm64_linux:   "753ec0b4dbf9b8decd7d1902f64c98630f5d50225226d4681aec063166fd2b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21dab7abe5a6f4c2c6ff59733b4e25232a5ec4bd0085adf179890a8b68b88b85"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"

  on_linux do
    depends_on "libtirpc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lxi.h>
      #include <stdio.h>

      int main() {
        return lxi_init();
      }
    C

    args = %W[-I#{include} -L#{lib} -llxi]
    args += %W[-L#{Formula["libtirpc"].opt_lib} -ltirpc] if OS.linux?

    system ENV.cc, "test.c", *args, "-o", "test"
    system "./test"
  end
end
