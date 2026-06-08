class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "80090e29d7fd0db472ddc663513f5be89bc936815e62b767e630c1d627279fe2"
  license "BSD-2-Clause-Patent"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e01f68c726d98ab10e5f0a7668b05a93abb2ddb6671ccb9acc5d0ec5935e7b8"
    sha256 cellar: :any,                 arm64_sequoia: "f9e880af99db9b5cfa6e9057f0c79f6eac3b432a879063dfafe879600144036d"
    sha256 cellar: :any,                 arm64_sonoma:  "742da9fc1c94e6a9b0216fe65028c4d37ecd33551bc0ce967a89ab0fedce7115"
    sha256 cellar: :any,                 sonoma:        "7fd7ea0a2db85c1a77bed99ddd4ef0762c210e2b19e59d6e04c312188424f4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c228eb0d2a8459b544ebfce6eaacde5cf5be9656a1987381fe9e960b9547f2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d001097d4789f9b10301a2a9fc7eb50c8c856db74dd609fea246e106f119d3ea"
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
