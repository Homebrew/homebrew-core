class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "d5d2d3d9bda783d69b88693da4d5de89a83320c82d779b56c5e351bcb024a4a6"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4536ac73f1b85b681eb384ef066ce493d3a5d14e3e740d6fb9786747856c8b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4536ac73f1b85b681eb384ef066ce493d3a5d14e3e740d6fb9786747856c8b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4536ac73f1b85b681eb384ef066ce493d3a5d14e3e740d6fb9786747856c8b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6df624bee3911f5f6c5f428acb15db968c0a9b730b3c240aedc92b75e35b272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "114ff1973edc52000147a709b3680ac2d60452d000466f27e6b9beddedd6e995"
    sha256 cellar: :any,                 x86_64_linux:  "91524e63b707309f266c1232f6c09d0fa2b1611dd40a4e13aa3fb7a2d5ff1ec8"
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
