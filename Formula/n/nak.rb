class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "cf83adf7796ab9a8208aecf4eb2bbd435b698dea44baabffee3fd909ab50b986"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6545658aef99218198af59862a1a15c425b7f3e4057f8bfb6456132b2dbac558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6545658aef99218198af59862a1a15c425b7f3e4057f8bfb6456132b2dbac558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6545658aef99218198af59862a1a15c425b7f3e4057f8bfb6456132b2dbac558"
    sha256 cellar: :any_skip_relocation, sonoma:        "00254095a630462e310d204e0bdb9cc3eca8963aeded081ce4936e7832c8d06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a865b0a237c91a8c6177292dc6100a24208f8d94c812f8dd471fe254cd1370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6232482008e06ecdc266c7226767db3719347f7481575454fea79c770d73f05e"
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
