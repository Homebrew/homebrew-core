class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.19.tar.gz"
  sha256 "94496b32fd544019dbca40b3f19fb03d186daf3b96857fb9cebed9124b4051d6"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "997b6e87729a9b05f5cbefce050d43f223e881f07ac7ff395e316bd32014f36b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libpthread-stubs"
    depends_on "libtirpc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lxi.h>
      #include <stdio.h>

      int main() {
        return lxi_init();
      }
    EOS

    args = %W[-I#{include} -L#{lib} -llxi]
    args += %W[-L#{Formula["libtirpc"].opt_lib} -ltirpc] if OS.linux?

    system ENV.cc, "test.c", *args, "-o", "test"
    system "./test"
  end
end
