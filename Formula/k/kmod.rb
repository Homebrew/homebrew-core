class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.3.tar.xz"
  sha256 "985554de49c21a58abd68c6cda2251384e1e5bb08b3b14c7f02b51f4c90c2958"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "073361ca529b18c7f9b0e8f176095f2633022359d5687b6a2012f759e329e724"
    sha256 x86_64_linux: "d5b794fc7e066ff22a16073de79188c57c6a6691285f4d84d935565e7f1e94a2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on :linux
  depends_on "openssl@4"
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  deny_network_access!

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
