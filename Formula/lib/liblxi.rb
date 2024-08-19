class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.20.tar.gz"
  sha256 "4ee8dc2daea6bf581c1da32c51c4cb08e3f3b42d4c77d8a19777f5bbae93f57a"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8b148d72e20e4613b694ae38ca3b032f4d105fb97e659887c7a86ab9adb42c1"
    sha256 cellar: :any,                 arm64_ventura:  "3f9e513d0056908d8727d4a8b5b83d625d83bae479871a165a1432c5e3bbc22b"
    sha256 cellar: :any,                 arm64_monterey: "bbba9e76bf693dfc99792ba17a350660ec2b76d8b3a13847f9d747578b6da241"
    sha256 cellar: :any,                 arm64_big_sur:  "e4dcfd51df02803ec63669c335623e972a440c7097a69d02c3d7b5590e7163d7"
    sha256 cellar: :any,                 sonoma:         "725dea2a1d77003f9bedf83d959f8ad659ffab5bf57987b730a0b7168525408b"
    sha256 cellar: :any,                 ventura:        "d60e0c52667699e11433b2dfa11f6c1e22c471d80715477a1d9de63c0c352e02"
    sha256 cellar: :any,                 monterey:       "6113392957d9239ab4c6910b7194fb18c8c3c732b2c4db312da53144d1d8935e"
    sha256 cellar: :any,                 big_sur:        "65730aa0af2e582967a738edcad6a8640e7a40d36becd7be19e05c601f79649d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab21945cac82d3233ce252006691421c03addb19a39abee90a1f9d9fe95cf80f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
