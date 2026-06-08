class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.xz"
  sha256 "5a5d5073070cc7e0c7a7a3c6ec2a0e1780850c8b47b3e3892226b93ffcb9cb54"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_linux:  "61677724c3f5a7390c6fb6b7ea9bb8a63d579be87223b4d1bc4a958c5a2413dd"
    sha256 x86_64_linux: "bf100adc797109c78f5a9811d224673e36f7670f90677cbf4d6ce1b5fbe49d3e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on :linux
  depends_on "openssl@3"
  depends_on "xz"
  depends_on "zlib-ng-compat"
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
