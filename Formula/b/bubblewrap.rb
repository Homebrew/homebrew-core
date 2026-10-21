class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.13.1/bubblewrap-0.13.1.tar.xz"
  sha256 "0e85c8702248b8dd64144f594147553650cdd0e4c951690345faace79c217c4d"
  license "LGPL-2.0-or-later"
  head "https://github.com/containers/bubblewrap.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "b3965b5d1e69038737c0dac498ef81a9bc57ca79f95dc8d10c36d836df6e0379"
    sha256 cellar: :any, x86_64_linux: "da3a3a91ad64cb5b5cdd04155078beba042160ebe81b0381bfbb0fcb795b16c6"
  end

  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "strace" => :test
  depends_on "libcap"
  depends_on :linux

  deny_network_access!

  def install
    # Meson modifies RPATHs during install but cannot handle paths injected by
    # our shim and results in a non-relocatable binary. Instead, we can remove
    # the shim RPATHs and pass them via the available meson option.
    args = %W[
      -Dinstall_rpath=#{ENV.delete("HOMEBREW_RPATH_PATHS")}
      -Dselinux=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "bubblewrap", "#{bin}/bwrap --version"
    assert_match "clone", shell_output("strace -e inject=clone:error=EPERM " \
                                       "#{bin}/bwrap --bind / / /bin/echo hi 2>&1", 1)
  end
end
