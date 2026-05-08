class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "606bd59110c234d2a423594e2a06c7bc2fd7c702618792d42284f1a0790906cb"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7feb3d1225ff371cd7c9243165bdd18cb7a884d576b6c0c279f80c826f204f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7feb3d1225ff371cd7c9243165bdd18cb7a884d576b6c0c279f80c826f204f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7feb3d1225ff371cd7c9243165bdd18cb7a884d576b6c0c279f80c826f204f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb263e3933d0c967561802a4d6c05d5867bfb4d13cbf76276245f16fd4ace7be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb5bedcdcbf74943d5109a6187a6f30e349aaa5eac2e98e2376f599ab0ec2738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ad65d6d6bd5ddabe0b8d448d1e237f17da9d5d52b8f95a170835f7a4fefa5b"
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
