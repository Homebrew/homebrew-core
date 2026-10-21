class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "603bab59a49a8dd76b2a025919a705d21d44c8e929c72c6ed5e7ad0e87fbc486"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5caf704b51a5f4dfa8309f5745cac17aef8c7296f5b5e692eff890f8a7c9e219"
    sha256 cellar: :any, arm64_tahoe:       "4b57c006cf85f7dcaea18e19b05d8c25b55d4c166b625bf480e35c7af03ee421"
    sha256 cellar: :any, arm64_sequoia:     "06edd9a9aae62a9eb6de5c9533d888c5960fd2064e6bdeda2c189f4b70826920"
    sha256 cellar: :any, arm64_linux:       "6924713364576ad033b3f8955ff6abbec70353a1f00d5e8a53deadea0510c916"
    sha256 cellar: :any, x86_64_linux:      "2f7da263f2626c6f5a02ceed30c918826a1b0b64fb4633e07e1200577c97fe32"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "glib"
  depends_on "libpaper"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_path_exists testpath/"paps.ps"
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
