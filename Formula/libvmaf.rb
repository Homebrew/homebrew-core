class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.5.2.tar.gz"
  sha256 "5f7785da0b0d66b2513ce11d3f81d0a9b3f79d49483c4652fde3a31c13f644da"
  license "BSD-2-Clause-Patent"

  bottle do
    cellar :any
    sha256 "ebea199beb3b71bd3ed5310c4bcb93a42039085f0ebcc9209b94845f61bd3f5c" => :catalina
    sha256 "ac339674e17c5facf37dcb6d2c39c612b4a05c023558958cb4de58b7affc3ad6" => :mojave
    sha256 "dac4209abe54273cd033960401ee6392219c3bb972c4185499c970a64edcf084" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
