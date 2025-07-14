class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "85d121087ea3e1139f63eaa389642bd6d8c2584728ec80d16315b17410844269"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ab3b695c06c0f9228bfd895ef79863a8e78a6b68e96b06774e703ac9075bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05ab3b695c06c0f9228bfd895ef79863a8e78a6b68e96b06774e703ac9075bd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ab3b695c06c0f9228bfd895ef79863a8e78a6b68e96b06774e703ac9075bd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6320979297527ca632fa428271fa3519e3382e90c6d02a6bc1fd8c0886d23ae8"
    sha256 cellar: :any_skip_relocation, ventura:       "6320979297527ca632fa428271fa3519e3382e90c6d02a6bc1fd8c0886d23ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7957fcca28005c5d81736033b68312872485b673a1e01ec53d1c7e98b11050b"
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
