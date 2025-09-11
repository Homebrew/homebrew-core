class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "95c4f14193e1cd89d9817babc760a00c7770f219e107f68d35efd441738f8092"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90dfe2454d42d4967b3e48ea4c3cfe69f034d2bb05ebafa7dd5d69a38194ed25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90dfe2454d42d4967b3e48ea4c3cfe69f034d2bb05ebafa7dd5d69a38194ed25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90dfe2454d42d4967b3e48ea4c3cfe69f034d2bb05ebafa7dd5d69a38194ed25"
    sha256 cellar: :any_skip_relocation, sonoma:        "8584d7d4db1117d009ef92b165e3e00f96e643858e778d816ab6b1c70e3e3b3d"
    sha256 cellar: :any_skip_relocation, ventura:       "8584d7d4db1117d009ef92b165e3e00f96e643858e778d816ab6b1c70e3e3b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b0b1c59db35c96916c748e99d8bf7118d33ff13f584818b32829f63387da1e"
  end

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  def install
    ldflags = "-s -w -X github.com/jpillora/chisel/share.BuildVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel")
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
