class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "af628f9a06a9050760f14466a0a82573cac363fd7ea54d44609f046b2422d3ca"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5848276e2f2c6b071c75a1ce2c4a655be215b50b7cd8c61e52c936afd4f17769"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "936cf76c90edd154f42b5eb0c06604ca8f64793d7e20cf91287ab31e61c2f9c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4908016f119477879d6cace0936ba2780aa780c9182c7c939c3fd975e41454"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e729ec279a5548a9a43e7d19f2f10b9d377e4f2ce3c599ee12aef7880ca0572"
    sha256 cellar: :any_skip_relocation, ventura:        "5c281998f83672825477277bc2901051403dd4f2d85006165a43e49b6e2f9270"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa4f1788000b7d4759481950dac11e34c6948f6379bbfd1dcdcbbf09509b43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52922fde06950cf80c1ba3d90684f8939a2194aaec9a64ca11c3388c11c810fb"
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
