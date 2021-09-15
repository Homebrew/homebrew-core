class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.2.0.tar.gz"
  sha256 "239e8e70ed2ae7b25f3a6ed9557f28c4ed287d5b1b82ce24da8916106864218f"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f2adac0ebf6a1d228baa816132efa0477bbdf53e3fed586927c17eba0d73d7db"
    sha256 cellar: :any,                 big_sur:       "903463941bf0fd5dc38c35c3893db9a9c97a587122ba49dd7db98d82e33164a2"
    sha256 cellar: :any,                 catalina:      "be05df065d1a6b5402fe6d9a2a68e9fb9184f752b125b366b79bc9c5560c0199"
    sha256 cellar: :any,                 mojave:        "9e6a47e5a4d145b5ed8e2be17de5eadca56425c27dee792310aee1baa9f51c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5874760e03675b5f171c3707959ef1205d5c82742f4240a36906c59d175454de"
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
