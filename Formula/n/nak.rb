class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "6bc8d39d4411dfc481b4c894932b76f55eeb152073adb4e55fe375c5ca049e5a"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6272bb74ceed6bcb079c5681ca309bc3f9fb0f26d725aee85781d1b8df0ccd2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6272bb74ceed6bcb079c5681ca309bc3f9fb0f26d725aee85781d1b8df0ccd2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6272bb74ceed6bcb079c5681ca309bc3f9fb0f26d725aee85781d1b8df0ccd2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb55a27e7e63741e70702ced43bbcbee0b863a46d5f75b3ce3dc4f61fc4727f5"
    sha256 cellar: :any,                 x86_64_linux:      "daba9da35b543d215b2188d5d4019868d6f2be0ebd9654885de5805a42b19a09"
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
