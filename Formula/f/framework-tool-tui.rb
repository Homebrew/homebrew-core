class FrameworkToolTui < Formula
  desc "TUI for controlling and monitoring Framework Computers hardware"
  homepage "https://github.com/grouzen/framework-tool-tui"
  url "https://github.com/grouzen/framework-tool-tui/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "1477bb7550e91c10b31ef3c660429ecfefa46848560db1f64788db30d5cde6e4"
  license "MIT"
  head "https://github.com/grouzen/framework-tool-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a2005c843187e8ed849654be5404438352d178e480f7e007749722eaee02e50"
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
