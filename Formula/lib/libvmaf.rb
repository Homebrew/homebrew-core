class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7178c4833639e6b989ecae73131d02f70735fdb3fc2c7d84bc36c9c3461d93b1"
  license "BSD-2-Clause-Patent"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bdc90ebc175c1f071be4ce895051586583177c3b1029817dc1078472a3da8261"
    sha256 cellar: :any,                 arm64_ventura:  "cc4765c5f45c5f87bcc42dba73fada9659abbf47bb9adb68bd406c26ac23380a"
    sha256 cellar: :any,                 arm64_monterey: "2c9b931ff4d557c6f731b1e834464f96e2620e77f1b857c2ec3061bb589e42da"
    sha256 cellar: :any,                 sonoma:         "a3ad27257fe552feb0d8ba3f2285feb7a6a772b845514e8d97bf0f9a9c0f1830"
    sha256 cellar: :any,                 ventura:        "28589a2b48fbd851749f57be19eda359e64056f289f899b80a52224dc3a6ad71"
    sha256 cellar: :any,                 monterey:       "bb97b9845e37e7090fecfff2e47c32c08c18ea4161da8d88134a7f7be4e07c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb81b38b8c402fc0c12a8a639a7208406958d27a1f8a513c706a5636903cdc4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vim" => :build

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
