class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "8c77ab35fe00209e8adb960dbeeb95fe0f48114ba37782b1cc19ba82f1b3c0c5"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf0c7c2082eab29320f1b51cb1b02bdaad982bd340dd5cff20bf43d785bc0bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf0c7c2082eab29320f1b51cb1b02bdaad982bd340dd5cff20bf43d785bc0bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf0c7c2082eab29320f1b51cb1b02bdaad982bd340dd5cff20bf43d785bc0bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "967cf5f87b415afa45e12ffa66c3afdba9a596341f9ba8bc33350a09f2ed6f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "639eb650b99a1abe59b65a85bb8daadc1129235e9a8647c3d03a1e51badc7d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101cbaea720edc68ede7f0714164513a35460fe1304d75b8d15b6de5e94f8289"
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
