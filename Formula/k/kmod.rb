class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.1.tar.xz"
  sha256 "125957c9125fc5db1bd6a2641a1c9a6a0b500882fb8ccf7fb6483fcae5309b17"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "a9c448f63fbe982988fd1a823f89ea41adfbf2460b8fd3f03eccae799b8064db"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on :linux
  depends_on "openssl@3"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = %W[
      -Dbashcompletiondir=#{bash_completion}
      -Dfishcompletiondir=#{fish_completion}
      -Dzshcompletiondir=#{zsh_completion}
      -Dsysconfdir=#{etc}
      -Dmanpages=true
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"kmod", "help"
    assert_match "Module", shell_output("#{bin}/kmod list")
  end
end
