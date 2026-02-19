class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "51d731f9a3e0022d38fc214cd0f6404c81baf18ac026cc332f2aaf74bbda4452"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e557be1204fb3d132bd6275f38862b097f7ee00faef62c2b3d748191b84a68c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e557be1204fb3d132bd6275f38862b097f7ee00faef62c2b3d748191b84a68c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e557be1204fb3d132bd6275f38862b097f7ee00faef62c2b3d748191b84a68c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c52db3cd04f00fca39a40f62c21104f233ee218f4d86779679b2a780f8570b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7621bd793daca7d188c42a1f186708822483a31e2484fa21cab085345249f1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c509b9bb3c0dc3d4fb02da70fdc43b206bdfce8443fe36a4d7a77d7a13578e1"
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
