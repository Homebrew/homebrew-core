class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "f91dfa39c0cf0dd721d5f8ec82bac46666c3ec2be1eb234b00b7524bc58122ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0acdec1f6697fd2780b8687a85d8ef2f064dcfd7190ba1fef1af1c8c5c21e37b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "699eeb423451adf11ea3113e96cc246955b9ed4c332b3db969a04439a619042c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac9d00cd223ff0bd482489d1df181f90558ea54fd7cd59df541b05f19beece9c"
    sha256 cellar: :any,                 arm64_linux:       "cc1eeba1f4646dedc57cf8f625f706d5e5edfbe6f9be9c236bf5b51461388734"
    sha256 cellar: :any,                 x86_64_linux:      "0b516cf88f529b2cfda8dae1ccba93a3e32ec6aaae9b344eb5cb0a7a846982cc"
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
