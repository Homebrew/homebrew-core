class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "fed288bfccc2a57e02643565f984047f92f114e40e886fe02b15bc455eca00a0"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daf015703a752a4786c905377001c47d17867503ca896bfaa6ea39e0a65a16cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf015703a752a4786c905377001c47d17867503ca896bfaa6ea39e0a65a16cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf015703a752a4786c905377001c47d17867503ca896bfaa6ea39e0a65a16cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "07575be7da4d9373dad3dbee2b9429097879f6d4fc6d956611dcec9106367b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f7711d21e5cbc15a36f9a65272f334c892c6ce726bfcbb433fcb092d7a44c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4137d698fc542b48866abc345d4f443f600a4057bb44cd4b227f5425d8b1191c"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
  end

  test do
    server_port = free_port
    server_pid = spawn bin/"chisel", "server", "-p", server_port.to_s, [:out, :err] => File::NULL

    begin
      sleep 2
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
