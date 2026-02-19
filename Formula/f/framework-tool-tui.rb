class FrameworkToolTui < Formula
  desc "TUI for controlling and monitoring Framework Computers hardware"
  homepage "https://github.com/grouzen/framework-tool-tui"
  url "https://github.com/grouzen/framework-tool-tui/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "b9210d9107454bd9fdf722b1167f1020579d0b3b3e949a429f9f91b7146b996d"
  license "MIT"
  head "https://github.com/grouzen/framework-tool-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f55174ec0723a0b70d3c1c3941e5c8f57569d691c99ce0549a43224b3ac3c6eb"
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
