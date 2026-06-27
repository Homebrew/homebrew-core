class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a28f93f3b4fa65601be324587072e32a6a704a304ba7b1aec9b70b3f709bc1dc"
  license "BSD-2-Clause-Patent"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb9f00a9f9ef91d725d1fcd23205642cedf8557e132f1e38bb9d16a22086beaa"
    sha256 cellar: :any, arm64_sequoia: "dbd548d2ba16092e9c88b81cd91d7cbd1ecec84b9bb31e9c196fe3f6658ee6b3"
    sha256 cellar: :any, arm64_sonoma:  "8fecc50c13e0b33b1e55a321d655d2a5dde3f4f941745de142cba758c41503f9"
    sha256 cellar: :any, sonoma:        "75b35c1c681e653f7046a485a4e29d214912dfa7d68d3d7668ec1c1943738214"
    sha256 cellar: :any, arm64_linux:   "c662ffa2b76b0b83f6e154205573a7901b0d8a890d7fc7858e65b7fd62bca77b"
    sha256 cellar: :any, x86_64_linux:  "bc908d0197dc5ae7de81cdbffb4164de779b26e13ed9fe50e583bc6ac194c3d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  uses_from_macos "vim" => :build # needed for xxd

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", "libvmaf", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    C

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
