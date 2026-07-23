class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "ffc085a1eb00230dfdb52d79fbc20a82aa20c6eafb8b8cd44348d2e33a4c4d32"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5151dee6d34ac2547b2843767b22fe22affdf337baed56dd21d4af99fd68f6ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5151dee6d34ac2547b2843767b22fe22affdf337baed56dd21d4af99fd68f6ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5151dee6d34ac2547b2843767b22fe22affdf337baed56dd21d4af99fd68f6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d76aa571f93190eeb5153a49b3c46543ca9f46ec4ed83247f00a3b5eea51875f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afee34fcd43aaa624bf9234b6a836830b7afeadbfe88dbf54eb1fe787e34d4fe"
    sha256 cellar: :any,                 x86_64_linux:  "6cc45fe372d17c65affaef6c73290aef0f8eb5035254d47ea1f9365969875ef0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
