class FrameworkToolTui < Formula
  desc "TUI for controlling and monitoring Framework Computers hardware"
  homepage "https://github.com/grouzen/framework-tool-tui"
  url "https://github.com/grouzen/framework-tool-tui/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "44e7ef61bdf228c4e12d1f96c983d175682a3c73753a7d921bbfe2653d498317"
  license "MIT"
  head "https://github.com/grouzen/framework-tool-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd3d42f76a0e28cf1ac4fa932b5f123592f9b30f0f66191ec3e525386bbc721f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on arch: :x86_64
  depends_on :linux
  depends_on "systemd" # for libudev

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # framework-tool-tui is a TUI application
    assert_match "The application needs to be run with root privileges",
      shell_output("#{bin}/framework-tool-tui 2>&1", 1)
  end
end
