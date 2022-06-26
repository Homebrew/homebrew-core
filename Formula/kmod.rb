class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-29.tar.xz"
  sha256 "0b80eea7aa184ac6fd20cafa2a1fdf290ffecc70869a797079e2cc5c6225a52a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0880a765bade6c140e9c0f8901e46db2f97d39951abf418ed701e03103f812d5"
  end

  depends_on :linux

  def install
    system "./configure", "--with-bashcompletiondir=#{bash_completion}",
      *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    bin.install_symlink "kmod" => "depmod"
    bin.install_symlink "kmod" => "lsmod"
    bin.install_symlink "kmod" => "modinfo"
    bin.install_symlink "kmod" => "insmod"
    bin.install_symlink "kmod" => "modprobe"
    bin.install_symlink "kmod" => "rmmod"
  end

  test do
    system "#{bin}/kmod", "help"
    assert_match "Module", shell_output("#{bin}/kmod list")
  end
end
