class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "af26e1e7d924a11cb1e06e09b0d93e0698a66df75318ead991d4d631b3397cb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd113c1c2ae8f0e62a32fc547e591515f097ecb57dbde6f0426ed66fce9d1388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e954c8dd7707e4e7d7611e0e8e1304f26d31c6d50568266010b6404d4c3e3af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7168703088c33870b62b98a6da113fa82ce41d113c6e3c43962ba79b72a76970"
    sha256 cellar: :any_skip_relocation, sonoma:        "71cbfc6dd90094b2de4f4bf1a6be92e93ded44bbe29c538d7ab99b4ac8e1036f"
    sha256 cellar: :any,                 arm64_linux:   "e3f39eecb4b354e33da1adf28369d73d0d4f3161cde6e36d503da3ac2427a5bf"
    sha256 cellar: :any,                 x86_64_linux:  "2e7e89a007183e6845b71b267520e1591f90a79f5eab220817da21315cbfcab5"
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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
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
