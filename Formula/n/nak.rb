class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "f40f6ea1c41731d64e5d5c47d207bcfafd3106e80148edc4d121a1f1c8270291"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb577ca0fe9be9a7f6c22554c9560c06dda8778625a9ea32bf1e7e24da10ad25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb577ca0fe9be9a7f6c22554c9560c06dda8778625a9ea32bf1e7e24da10ad25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb577ca0fe9be9a7f6c22554c9560c06dda8778625a9ea32bf1e7e24da10ad25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d386b02f7d4969093c2b63f374e7e1a1e0bafea22789d0e63fa1f6686468e992"
    sha256 cellar: :any,                 x86_64_linux:      "6fd18835aef7101a1b91fa6881c70614e6acb56bd40c4b9546394f7859278978"
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
