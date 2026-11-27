class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3cf1616c734b51864f16d2672c3f53a983af9055a58a153584ad4ab98cdb55ec"
  license "MIT"

  bottle do
    manifest_sha256 "fff4cbc486aa15cf09a2957315189e0ea078238c14767de7a900c69e5034e283"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb3e78940775866cafd5f132e62e0a03019f8ab0a5cdcbc4858dadf00f1da723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "512ce7dc34bac395a54d7ae379ba9488841f5e779eff04eae51e5e56eb1b6b40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "873f4dd489de28cd71229bf47164758160a5f7b917873b7f1e4650f2a4c2e61c"
    sha256 cellar: :any,                 arm64_linux:       "b67edd5480b9086e0290bd134948ef83fe49820d06918411cb23c057b31f6c7e"
    sha256 cellar: :any,                 x86_64_linux:      "679eeb90d280bf5da13b8ad42c4078a57508f8acfc8ed1765a8123625489b0f0"
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
