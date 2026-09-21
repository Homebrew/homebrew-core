class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.12.0/bubblewrap-0.12.0.tar.xz"
  sha256 "9760d007363e3abba7c747489910f9f82d9fca53ba3bd3282e396fa3c97a3314"
  license "LGPL-2.0-or-later"
  head "https://github.com/containers/bubblewrap.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "5686efdc4be3485197c3a3d233c8a84ce3c75ea7100505d310b97dd39c9a8ab7"
    sha256 cellar: :any, x86_64_linux: "bec8000dda883e2132de16cd22334e8e1d4df8a3c246acdfc9b5d8b07fdfade8"
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
