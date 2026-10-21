class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "0a5697327926d54b0c8b0b0ea6ad99ee718a0cfd4bd872b70a08b191221ae0ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6da99a892e376f19c8f728621f0e202b02beb2b4fa1fc41269fd4e7cc1bc1450"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec452d97927cca7dc0add7c2383653bd283a9838a4a9a7b65700fe3b07974824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1899faa0fb1975a535410be3d153246bfa0486d5654484a8f0ce5dc4955ffad3"
    sha256 cellar: :any,                 arm64_linux:       "d1a08e7798ea283716cad092d96fa96d9a4ce7bc08ab9c5fc118ee04cbdf2efb"
    sha256 cellar: :any,                 x86_64_linux:      "0b1b8b0e3294c8a36dc6f4711d4f53b352c67f5b1c533b4a4aa10b3d5325f0ec"
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
