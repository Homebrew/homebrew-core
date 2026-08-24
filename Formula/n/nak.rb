class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "3a848d42c4df7172a1f7cdd9e31018005b2efd54c9ff8cfef7dad94e689c9957"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8e082ce1fb32c86d709b94675a36389b76c29d5f35cce3cf39fb7168b741c3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e082ce1fb32c86d709b94675a36389b76c29d5f35cce3cf39fb7168b741c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e082ce1fb32c86d709b94675a36389b76c29d5f35cce3cf39fb7168b741c3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "50e42350e371fecb4c68d8d561fd2a71088469dcee2405a493c6685af3804627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c30c1cad36e8d18496e7bac4fcadcb68bde4b2c6341238bf10cd4b259dbbe9e1"
    sha256 cellar: :any,                 x86_64_linux:  "fe4d3ceec063e80ffdeba191c1b3e7bd278d42972065dc1040a9992a072d4279"
  end

  depends_on "go" => :build

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
