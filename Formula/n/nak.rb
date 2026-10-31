class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "a4bf489317fe346c582d46fce041244fd0b7e4bed05b3bfbf9d09863e540a01a"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28e2ff328e6858c34a5b928d5f9e4e9e67ebf0dc75faa971b7979449891ce31c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28e2ff328e6858c34a5b928d5f9e4e9e67ebf0dc75faa971b7979449891ce31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28e2ff328e6858c34a5b928d5f9e4e9e67ebf0dc75faa971b7979449891ce31c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b70b91520282d9cabdcf4a4ca0a0f4cf1df6c77c59387be845bc3cc0c10b13c"
    sha256 cellar: :any,                 x86_64_linux:      "93c9f5f6414693aebe5cbbc47216f32f7bbcddb59d9ae85ae6d6229cf5a742ff"
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
