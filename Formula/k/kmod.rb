class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-32.tar.xz"
  sha256 "630ed0d92275a88cb9a7bf68f5700e911fdadaf02e051cf2e4680ff8480bd492"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92f97941033e512c0489249f4cb7573c45b9424286daedf688f6634892f01834"
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
