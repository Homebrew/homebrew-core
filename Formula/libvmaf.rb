class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.5.3.tar.gz"
  sha256 "440652ae417d88be083ffd9fa5967662172601e31c458a9743f6008d7150c900"
  license "BSD-2-Clause-Patent"

  bottle do
    cellar :any
    sha256 "3ff54681fdedd65aa05925a0a5deb941e2b48ecdc946bb83358013e4a53f46f3" => :catalina
    sha256 "fe3f8995fa8ce2c13af693e40581dc93e63e22821fa3fe007430a2acd3bca6da" => :mojave
    sha256 "c701af393db9948a5d804607237678b232a32d7501de39c482095353c5f7d3b6" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
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
