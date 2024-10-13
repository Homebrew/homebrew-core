class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.10.0/bubblewrap-0.10.0.tar.xz"
  sha256 "65d92cf44a63a51e1b7771f70c05013dce5bd6b0b2841c4b4be54b0c45565471"
  license "LGPL-2.0-or-later"

  head "https://github.com/containers/bubblewrap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa946be36b820862412056195fe6babefd58f6c8b87795cf4f5cb29bb0804df0"
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
