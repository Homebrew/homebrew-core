class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.1.tar.gz"
  sha256 "8d60b1ddab043ada25ff11ced821da6e0c37fd7730dd81c24f1fc12be7293ef2"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddf330046166c9f25ad89679d04bc12375d3ad8b4454edeebb2e39667af53dce"
    sha256 cellar: :any,                 arm64_monterey: "780fe80d3941971968a0dfe1f8384fc5fc240e9994b09da41175a7d5fc56b513"
    sha256 cellar: :any,                 arm64_big_sur:  "76b4b46c07bde41001d5dd6660de656c369b1cf9653638538348e97ffaeec55f"
    sha256 cellar: :any,                 ventura:        "433acd17cf9b2bc4aca330fd9f27d32e2edbc62445df948fcf6030ec20fb47a4"
    sha256 cellar: :any,                 monterey:       "a30aaf6bd5878809c3dec5f47d643e4adbda5811a13f5a20d21a3472d5151e2a"
    sha256 cellar: :any,                 big_sur:        "60fb7784b39ae2aff9a836f08190637e9c7f2ac32755ed24ec3f5ddbac916c64"
    sha256 cellar: :any,                 catalina:       "99db9a406ddacb8ca0c157dbea53eb12a29ced66091f2af820ae8bf9bc9802cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6697226f2c628ce462531ad546f8152b264f29151710cdb064659ac321cb92a4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
    pkgshare.install "model"
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
