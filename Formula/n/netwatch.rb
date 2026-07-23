class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "3600dadbba659d56d2dede32a384923ebf3cdf91af96c13b1efdaaee23302ba9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb926fc8b0e131cd48dcc42cd29a059a4a663825a42abed96b2e0fbb379d8c61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a732f18fc55f048768102012d7cc409798b5bd25cc643dee2d9b4d96760b8c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2357b2a774344a56be63b0e6bd968d1abddcade2b709e7ee3d5385277bfaee9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeac2c43f332d018bdabd85f71236ce14e69dbeef4ad64cefb8a79d29a9c449a"
    sha256 cellar: :any,                 arm64_linux:   "38cf9bfdb71971bdf227dc3ed606323fe18871212d0b9a591b442b34a24b0f66"
    sha256 cellar: :any,                 x86_64_linux:  "d1c6beede893b6af182901ee1822c7888db4626a6f9339e84f848f1e4634834f"
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
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
