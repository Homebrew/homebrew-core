class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "506752739c3040efef5aee3848b3255e72a50054aed924650c15cb0eaeaec0ba"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "857411a760d4904963e06f9bdffcf301384aa45377aa099543047eac6b149b52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857411a760d4904963e06f9bdffcf301384aa45377aa099543047eac6b149b52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857411a760d4904963e06f9bdffcf301384aa45377aa099543047eac6b149b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "5deb921e8811fd9fba86bf1dc9f0d2a0867cf302e781358e69c50c12b539f4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "326e4ebd3c697145276a2e0f5f0cbf3175d0425e30e3587a34ca9a010628b3b6"
    sha256 cellar: :any,                 x86_64_linux:  "65afe277bd75ae87a85acdb8919c7af74f6c0f323d891bafa243683b815369f4"
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
