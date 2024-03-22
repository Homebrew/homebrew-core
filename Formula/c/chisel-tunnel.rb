class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "7323fb3510a36f14949337cd03efd078f4a5d6159259c20539e3a8e1960a7c7e"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5037b5ae58ec1a0eb1fe11b26efa6838587c624a37c2bd770a1628ac9cb3316"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99d3c362ac14ef78c792399308994e9be4509a0b2ea31aea95e82b10f37e271f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50fca28c7c5be10d023efb49e9ac2be728e90285491e39ffba5a3afed39eabc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e0fc64e4471956b20c175cec8a06cd27363648d71856207d20b6b883271cbf6"
    sha256 cellar: :any_skip_relocation, ventura:        "825b46a233b6a10768e50f06d53bd8cec945457ee8be0889fa65901749aa6d48"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1fb7177adbcaa8ba3ba3a5fd0a0c7d51ffccea5da2a46f3d3c2bf3094461ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955d2db76211bd1fef5a447b7281d7f058144fcfde65b087970d188fbaf613e3"
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
