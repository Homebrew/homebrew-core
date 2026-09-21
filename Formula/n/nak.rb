class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "a6f4b9770ec3532cd0f52621aa3499cfd5d25251e4c105be9df6a32b09721961"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "772ae31bba3eb69615682785b6853e844a66fc1f0458ee5ba223313ca26ec507"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "772ae31bba3eb69615682785b6853e844a66fc1f0458ee5ba223313ca26ec507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "772ae31bba3eb69615682785b6853e844a66fc1f0458ee5ba223313ca26ec507"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7752b8a540ff14e80a0666da31281f3e3d4147acf4dd2526ca06226f16dd0e37"
    sha256 cellar: :any,                 x86_64_linux:      "6534a206e55a2efc78c3b8558d568a945444889808d6e38d6a584b2dfa59de6b"
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
