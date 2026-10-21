class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "8697267ad1a5a8235f1382ed91437939b2d01167cb46bdc98f1b3a6022db5da5"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b464e8d43c6a0c2e90daa8db65691fe8f368c8f3ddcedc18b999f827c7c79d97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b464e8d43c6a0c2e90daa8db65691fe8f368c8f3ddcedc18b999f827c7c79d97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b464e8d43c6a0c2e90daa8db65691fe8f368c8f3ddcedc18b999f827c7c79d97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de7600b60f89a808d9e72e5a0340fe6284d36ae5823046c456d4ffdfc545b04b"
    sha256 cellar: :any,                 x86_64_linux:      "f5e2e95ce470335798dcd4df87d3713f599d440347dc0dd0fb6d236207adce88"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  def shell_output_with_tty(cmd, expected_status = 0)
    return shell_output(cmd, expected_status) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal expected_status, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    relay_output = shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1", 123)
    assert_match "failed to fetch 'listblockedips'", relay_output
  end
end
