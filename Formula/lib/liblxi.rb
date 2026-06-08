class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.22.tar.gz"
  sha256 "d33ca3990513223880ec238eb2e5aa1cc93aff51c470ef0db9df3e0c332493d5"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90b99e8ef648703285fa24caf9d05f63402da9cc0d9c64860ca2559ed3c0fa7b"
    sha256 cellar: :any, arm64_sequoia: "18d6b33c092ccdac797c676b1805f09da03bf985530f691016fa1928adb3ca66"
    sha256 cellar: :any, arm64_sonoma:  "20811fe73cca39574313757b888a06e8fbd8ce4d347d5cff8d43d244bc23ab93"
    sha256 cellar: :any, sonoma:        "d16e24e3272e1036851c6ec820e9a328dadb3c79dbf35e8fc81e4fc97660344e"
    sha256               arm64_linux:   "7c962e15081bbdd29b93a4714f8a3f3b27225fbf209ffa3d39415d6fd5c63911"
    sha256               x86_64_linux:  "3a3ea1867af1936c3d441d4799fd7b448701e984679be728dffdee1cd24f8728"
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
