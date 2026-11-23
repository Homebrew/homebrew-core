class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.4.tar.xz"
  sha256 "4c7942dda4793d08f975270322db582c9701438afd4d76ed9e6e7cf4094cb967"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/"
    regex(/href=.*?kmod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "b544e8c775734994edbe7204138ed9ebbe98e594c9fe811c2ad9bb3c926c1121"
    sha256 arm64_linux:  "e2e9d906967bbe2c0c0ffa591248170c0ebb267591c3a90e527be11a63034ca3"
    sha256 x86_64_linux: "f6a258a9c6ede3ecf99c8ffba746596a8baec67ceab554dda253603f5f0e2ec4"
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
