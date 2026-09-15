class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.31.4.tar.gz"
  sha256 "9ebc3da8164ba829544e0551577b039c6c14761bb9ab908cd54070a5eb09607c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86d8c999ccb2bc27480502e243c6df6508a31839dd4a6bb1677f6fef13fa89b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6ae9880dd5b971c488f79710ce6fa0d78b2b10e5c3f842eb1b472ebd523b91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a2fad031b1e89b717c36c0796d404f72b0ab86b0b537ce5bcf2b4e26a7f8252"
    sha256 cellar: :any,                 arm64_linux:       "0573e232a291a85fccf833660dd90db82b9edcfbe4ec3be05a0ab97d53da28e5"
    sha256 cellar: :any,                 x86_64_linux:      "ca80e1431032b851dad696e41022260ef4029cbe780d588d446ab1d8881958cc"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
