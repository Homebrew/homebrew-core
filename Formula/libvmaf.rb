class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.2.0.tar.gz"
  sha256 "239e8e70ed2ae7b25f3a6ed9557f28c4ed287d5b1b82ce24da8916106864218f"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0fd8b244f5af275a57821309bcc2642c9462ea2036f352eeca9e1d1483eecbad"
    sha256 cellar: :any, big_sur:       "ea59729308a5b85828585e7b595ef71f012423542869742e050de3129c4724b1"
    sha256 cellar: :any, catalina:      "87e4303e5885e6084a7757d40344d808e6a4aafa24570d98301c940b61abc383"
    sha256 cellar: :any, mojave:        "c72c463e289f60c067861d0993894cfdc65a34a88435ced1506dac9066d008f6"
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
