class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "85d121087ea3e1139f63eaa389642bd6d8c2584728ec80d16315b17410844269"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b397a8a01fc38a83f555b0f13e7ff9a35aebb841429fc2fd3b3eac677a710c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b397a8a01fc38a83f555b0f13e7ff9a35aebb841429fc2fd3b3eac677a710c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b397a8a01fc38a83f555b0f13e7ff9a35aebb841429fc2fd3b3eac677a710c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c340b49c0b6562f7b6e27750cb5ae2b0e693a9705277a7e6b0294c51044effa6"
    sha256 cellar: :any_skip_relocation, ventura:       "c340b49c0b6562f7b6e27750cb5ae2b0e693a9705277a7e6b0294c51044effa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636bb604a3dc5845c89843386b4ef6c877f72110c3099403471239a6fbd1e0ba"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"chisel", ldflags: "-X github.com/jpillora/chisel/share.BuildVersion=v#{version}")
  end

  test do
    _, write = IO.pipe
    server_port = free_port

    server_pid = fork do
      exec "#{bin}/chisel server -p #{server_port}", out: write, err: write
    end

    sleep 2

    begin
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
