class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.9.0/bubblewrap-0.9.0.tar.xz"
  sha256 "c6347eaced49ac0141996f46bba3b089e5e6ea4408bc1c43bab9f2d05dd094e1"
  license "LGPL-2.0-or-later"

  head "https://github.com/containers/bubblewrap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a1f4b5ef0aaf9e6bf6a9f573c922702e8b0103dd7af93bb92d2ab33b71902e5"
  end

  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "strace" => :test
  depends_on "libcap"
  depends_on :linux

  def install
    args = %w[
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
