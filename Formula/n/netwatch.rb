class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f72a0d41530f86f81a18f719b59115fd3a995e211eadda35685f68ceba469164"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaf0a87c5134a9fcfce31bad3c3d0f7511d3f79ba4b898e12f7abfabda8dc355"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77b19610e2bb390899a311b081ed8ffdf139ea2f50eef7030fb233ded4047672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fc3085ce11f2dac2097319704408b00252b11d2989d66af9a7803da9daca7ea"
    sha256 cellar: :any,                 arm64_linux:       "ac204faf895836fe8f34e806c70d1ed3cd49aca13166cd55b1c9c0697741d731"
    sha256 cellar: :any,                 x86_64_linux:      "318fb47e24f46d48ad45e363bef213b4b5844451242886b277059f4b3791e9bd"
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
