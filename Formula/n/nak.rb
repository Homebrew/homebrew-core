class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "e95487bee31be6380c63a020122c11a8b7a31fb29b892417434b039f614651cd"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ecf1e4e09a2cd4a264e3c79d348f95859a5a155faf97d64d79252702a2abc38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecf1e4e09a2cd4a264e3c79d348f95859a5a155faf97d64d79252702a2abc38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ecf1e4e09a2cd4a264e3c79d348f95859a5a155faf97d64d79252702a2abc38"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4329ab52c730178765cf78c374941c300f157c2570288d59924b705413a1944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3abdbbb66f3fc09baea791b2176297922fe58689922c3507dce0ceeb21eceab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d73585e4f4a94c9d28515748c3a205cd05ed0a0939cdd7b7f2ad68d0bb2cd2f"
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
