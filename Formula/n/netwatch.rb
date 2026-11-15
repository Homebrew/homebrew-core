class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "0a8cccd31d1ffff41f6ab832731e4de02885078d8475750fd1a9baafb894d727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "492902bd64e4a25ebf9508d42178d8ae3d5ba5dd392cd59c0187fa01c651cb21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38d0d86ff5154a8a5377738f97bf3f827a5e7e37cf73c761714d8c5e514a1a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66e4f2b4108cba6442a1cf6f78f3dc3ead871b4e8300ca4337cf9da435e8698f"
    sha256 cellar: :any,                 arm64_linux:       "b60050516ca0090a888d3ac49af5c5981fdface475f76233aeb0d87e3056f2ba"
    sha256 cellar: :any,                 x86_64_linux:      "ed4864f58ed1ee17c301376728bde96f95567470daa79c33b2c6db2c8961001c"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

    screenlog = (testpath/"screenlog.ansi").binread
    assert_match "topo", screenlog
    # match text in help dialog
    assert_match "Toggle this help overlay", screenlog
  end
end
