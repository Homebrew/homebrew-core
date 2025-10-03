class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz"
  sha256 "988fd6b232dafa04b8b8198723efeaccdb3c6aa9c1c7936219d5791a8b7a8646"
  license "LGPL-2.0-or-later"
  head "https://github.com/containers/bubblewrap.git", branch: "master"

  bottle do
    sha256                               arm64_linux:  "0b9837b33f5d2858266ca6eea7c436a43115cbd2cc322f45601862d4d0f00051"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6694f22b5343dc2dbb81adf6ff9fcd5a37ee6fe1757e96b4966367e766dcfe4"
  end

  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
