class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.0.tar.gz"
  sha256 "d8dcc83f8e9686e6855da4c33d8c373f1735d87294edbd86ed662ba2f2f89277"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fee5dad3a7de18f2e298a162730f2c12bf571ae46677f610a549676a932167fe"
    sha256 cellar: :any,                 big_sur:       "14cbc4c13ca4638b1bfab15320451eaaad85a0d1f02850a7ea2cdeadcc996d5f"
    sha256 cellar: :any,                 catalina:      "473bc63397de71d332e7bc2ce96ebaf7dd9aa79127b75b33fd1a344cac8d95ff"
    sha256 cellar: :any,                 mojave:        "960cb12eb62f5a3eee4c7ff5bed852d58d340dd4bb0be98e2aadf470f85cdbfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbf4bc9099b33a927cbf16548d40b5a9cf5e4adb42527ff60d84a063a11db10"
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
