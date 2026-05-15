class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "85ff0c6131dae3689344e4a9c86a38c46419d215d8c3a47991b423f766d403e8"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e93a3a1b006fd16239ee00f3ee3d6bb376c499d3688d229750b996bde5f639ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93a3a1b006fd16239ee00f3ee3d6bb376c499d3688d229750b996bde5f639ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93a3a1b006fd16239ee00f3ee3d6bb376c499d3688d229750b996bde5f639ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "11facc584c3ded0b7891d77035b64abb2e98d33738724e65e275597bc9dd2c8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebac4d31fa437975c0122ca6c7eadb17b94a0aacdcfe7ee86ed7afcfc1f6f8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf1d3c0ae10a7fb9fb1545d359d7c34f5af8a01352fd969e33d92199e7f6b92"
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
