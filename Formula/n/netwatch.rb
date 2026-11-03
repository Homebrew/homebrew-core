class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f72a0d41530f86f81a18f719b59115fd3a995e211eadda35685f68ceba469164"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7850cd65cf4b8658383b0399202ea76da1574ce9864bc44940117e99cf30ce27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c46060eb2d99ed07e40dbcc3d64c0cbe7c20a8b8dbb0968af0b6d632a53eda05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c63bd239bcd183f70a02d03bf9329bf8cc7dbee68d638dd163dca6e8db5c7c25"
    sha256 cellar: :any,                 arm64_linux:       "ae932fe8ab6402daa1daa2f2d0e4b534ec09eb3da115db68ca4473461c94be5e"
    sha256 cellar: :any,                 x86_64_linux:      "862641fafbac0e33a5cae03396d8d24cab3c3c52f862a987b01a84175674a529"
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
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
