class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "b8fbd360984d9903a636cc7a0daa5ac123b2a31ead3424137fdcc31e2a36e71c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e544488778b7af3a454de8df59c54697e20fe011ac45df0d19b6febc4ca3ed49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e544488778b7af3a454de8df59c54697e20fe011ac45df0d19b6febc4ca3ed49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e544488778b7af3a454de8df59c54697e20fe011ac45df0d19b6febc4ca3ed49"
    sha256 cellar: :any_skip_relocation, sonoma:        "94cff9dd6376dd746bf7ae93df2a391eb9e333437343d4b03062d9e87b766662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2587dca6e7aca438787a429840229647965a92647a9dae77de416045baf411d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceacbdb6194fe2dfe2cb15d13c1bea4523c6795a96735c3cd6798e6dde8d820d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def shell_output_with_tty(cmd)
    return shell_output(cmd) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1")
  end
end
